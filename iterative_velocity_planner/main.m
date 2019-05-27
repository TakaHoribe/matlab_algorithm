
a_max = 3.0;
d_max = 3.0;
j_max = 0.1;
epsilon = 0.01;

s_arr = 0:1:100;
v_arr = ones(size(s_arr)) * 10.0;
v_arr(50:end) = 5.0;
v_arr(80:end) = 0.0;



figure(1);
plot(s_arr, v_arr, '--k'); grid on; hold on;
p = [];

while (1)
    v0 = v_arr;
    v_arr = limitlongitudinalaccel(s_arr, v_arr, a_max, d_max);
    v_arr = limitlongitudinajerk(s_arr, v_arr, j_max);
    
    figure(1);
    delete(p);
    p = plot(s_arr, v_arr);
    drawnow;
    norm(v0 - v_arr) 
    if norm(v0 - v_arr) < epsilon
        break;
    end
end

legend('base', 'iter 1', 'iter 2', 'iter 3', 'iter 4');

% plot acceleration and jerk







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
        tmp1 = (s(i-1)*s(i) - s(i-1)*s(i+1) - s(i)*s(i+1) + s(i+1)^2);
        tmp2 = (s(i-1)*s(i) + s(i-1)*s(i+1) - s(i)*s(i+1) - s(i-1)^2);
        tmp3 = (s(i-1)*s(i) - s(i-1)*s(i+1) + s(i)*s(i+1) - s(i)^2);
        j(i) = 2 * v(i+1) / tmp1 - 2 * v(i-1) / tmp2 - 2 * v(i) / tmp3;
        if j(i) > j_max
            v(i) = -(j_max - 2 * v(i+1) / tmp1 + 2 * v(i-1) / tmp2) * (tmp3 / 2);
        end
        if j(i) < -j_max
            v(i) = (j_max + 2 * v(i+1) / tmp1 - 2 * v(i-1) / tmp2) * (tmp3 / 2);
        end
    end
end


