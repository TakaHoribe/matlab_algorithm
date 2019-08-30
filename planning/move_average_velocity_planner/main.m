clear all;

dt = 0.1;
a_max = 1.0;
d_max = -a_max;
jerk_max = 0.3;

v0 = 2;
a0 = 0.3;

N = ceil(a_max / jerk_max /dt);

t = 0:dt:80;
L = length(t);

v = ones(size(t));
v(1:floor(L/5*0.6)) = 1;
v(ceil(L/5*0.6):floor(L/5*0.8)) = 2;
v(ceil(L/5*0.8):floor(L/5)) = 1;
v(ceil(L/5):floor(L/5*2)) = 2;
v(ceil(L/5*2):floor(L/5*3)) = 4;
v(ceil(L/5*3):floor(L/5*3.1)) = 2;
v(ceil(L/5*3.1):floor(L/5*4.)) = 4;
v(ceil(L/5*4.):end) = 0;

x = zeros(size(t));
x(1) = 0;
for i = 2:L
    x(i) = x(i-1) + (v(i) + v(i-1)) / 2 * dt;
end

v_orig = v;

v = v - (0.5 * a0 / jerk_max);


v_curr = v0;
a_curr = a0;
v_f_a = zeros(size(t));
a_f_a = zeros(size(t));
s_f_a = zeros(size(t));
for i = 1:L
    v_f_a(i) = v_curr;
    a_f_a(i) = a_curr;
    if v_curr < v(i) - a_max * dt
        v_curr = v_curr + a_max * dt;
        a_curr = a_max;
    elseif v_curr > v(i) - d_max * dt
        v_curr = v_curr + d_max * dt;
        a_curr = d_max;
    else
        a_curr = (v(i) - v_curr) / dt;
        v_curr = v(i);
    end
end
for i = 2:L-N
    s_f_a(i) = (a_f_a(i) - a_f_a(i-1)) / dt;
end



x_f_s = zeros(size(t));
v_f_s = zeros(size(t));
a_f_s = zeros(size(t));
s_f_s = zeros(size(t));

a_f_a_tmp = [ones(1,N-1) * a_f_a(1),a_f_a];
    

% 移動平均フィルターをaccにかける
for i = 1:L
    a_f_s(i) = sum(a_f_a_tmp(i:i+N-1)) / N;
end
v_f_s(1) = v0;
for i = 2:L
    v_f_s(i) = v_f_s(i-1) + (a_f_s(i) + a_f_s(i-1)) / 2 * dt;
    s_f_s(i) = (a_f_s(i) - a_f_s(i-1)) / dt;
end
x_f_s(1) = 0;
for i = 2:L
    x_f_s(i) = x_f_s(i-1) + (v_f_s(i) + v_f_s(i-1)) / 2 * dt;
end


figure;
subplot(4,1,1); plot(t, [x; x_f_s]); grid on;
subplot(4,1,2); plot(t, v_orig,'k--'); hold on; plot(t, v, 'b-'); plot(t, [v_f_a; v_f_s]); grid on;
subplot(4,1,3); plot(t, [a_f_a; a_f_s]); grid on;
subplot(4,1,4); plot(t, [s_f_a; s_f_s]); grid on;