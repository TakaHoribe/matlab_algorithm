dt = 0.001;
a_max = 3.0;
d_max = -3.0;



t = 0:dt:20;
L = length(t);

v = ones(size(t));
v(1:floor(L/5)) = 5;
v(ceil(L/5):floor(L/5*2)) = 2;
v(ceil(L/5*2):floor(L/5*4)) = 4;
v(ceil(L/5*4):end) = 0;






v0 = 5;
v_curr = v0;
v_f_a = zeros(size(t));
a_f_a = zeros(size(t));
s_f_a = zeros(size(t));
for i = 1:L
    v_f_a(i) = v_curr;
    if v_curr < v(i) - a_max * dt
        v_curr = v_curr + a_max * dt;
        a_f_a(i) = a_max;
    elseif v_curr > v(i) - d_max * dt
        v_curr = v_curr + d_max * dt;
        a_f_a(i) = d_max;
    else
        a_f_a(i) = 0;
    end
end
for i = 2:L-N
    s_f_a(i) = (a_f_a(i) - a_f_a(i-1)) / dt;
end

v_f_s = zeros(size(t));
a_f_s = zeros(size(t));
s_f_s = zeros(size(t));

N = 800;

for i = 1:L-N
    a_f_s(i) = sum(a_f_a(i:i+N))/N;
end
v_f_s(1) = v0;
for i = 2:L-N
    v_f_s(i) = v_f_s(i-1) + a_f_s(i-1) * dt;
    s_f_s(i) = (a_f_s(i) - a_f_s(i-1)) / dt;
end


figure;
subplot(3,1,1); plot(t, [v; v_f_a; v_f_s]); grid on;
subplot(3,1,2); plot(t, [a_f_a; a_f_s]); grid on;
subplot(3,1,3); plot(t, [s_f_a; s_f_s]); grid on;