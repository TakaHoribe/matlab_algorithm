
a_max = 3.0;
d_max = 3.0;
j_max = 0.3;
epsilon = 0.0001;

s_arr = 0:0.1:100;
v_arr = ones(size(s_arr)) * 10.0;
v_arr(500:end) = 3.0;
v_arr(700:end) = 9.0;
v_arr(800:end) = 0.0;

v_orig = v_arr;


% figure(1);
% plot(s_arr, v_arr, '--k'); grid on; hold on;

p = [];
i = 1;
tic;
while (1)
    v0 = v_arr;
    v_arr = limitlongitudinalaccel(s_arr, v_arr, a_max, d_max);
    [v_arr, j_arr] = limitlongitudinajerk(s_arr, v_arr, j_max);
    fprintf('i = %d, norm = %f\n', i, norm(v0 - v_arr));
    if norm(v0 - v_arr) < epsilon
        break;
    end
    i = i + 1;
end
toc;

% figure(1);
% delete(p);
% p = plot(s_arr, v_arr);

% plot acceleration and jerk
a_arr = zeros(size(v_arr));
for i = 1:length(s_arr)-1
    ds = s_arr(i+1) - s_arr(i);
    dv = v_arr(i+1) - v_arr(i);
    a_arr(i) = dv / ds * v_arr(i);
end

figure(2);
subplot(3,1,1); plot(s_arr, v_arr, s_arr, v_orig, '--k'); grid on; legend('v[m/s]')
subplot(3,1,2); plot(s_arr, a_arr); grid on;legend('a[m/s2]');
subplot(3,1,3); plot(s_arr, j_arr); grid on;legend('j[m/s3]');
xlabel('arclength [m]');




function v = limitlongitudinalaccel(s, v, a_max, d_max)
    N = length(s);
    for i = 2:N
        ds = s(i) - s(i-1);
        v(i) = min(v(i), sqrt(v(i-1)^2 + 2 * a_max * ds));
    end
    for i = N-1:-1:1
        ds = s(i+1) - s(i);
        v(i) = min(v(i), sqrt(v(i+1)^2 + 2 * d_max * ds));
    end
end


function [v, j] = limitlongitudinajerk(s, v, j_max)
    N = length(s);
    j = zeros(N, 1);

    for i = 3:N-2
%     for i = N-2:-1:3
        x = s(i-1)*s(i);
        y = s(i-1)*s(i+1);
        z = s(i)*s(i+1);
        tmp1 = (x - y - z + s(i+1)*s(i+1));
        tmp2 = (x + y - z - s(i-1)*s(i-1));
        tmp3 = (x - y + z - s(i)*s(i));
        j(i) = 2 * v(i+1) / tmp1 - 2 * v(i-1) / tmp2 - 2 * v(i) / tmp3;
        if j(i) > j_max
            v(i) = -(j_max - 2 * v(i+1) / tmp1 + 2 * v(i-1) / tmp2) * (tmp3 / 2);
        end
        if j(i) < -j_max
            v(i) = (j_max + 2 * v(i+1) / tmp1 - 2 * v(i-1) / tmp2) * (tmp3 / 2);
        end
    end
end


