%%

clc
clear variables;
% close all;

set(0, 'defaultAxesFontSize', 12);
set(0, 'defaultTextFontSize', 20);
set(0, 'DefaultAxesLineWidth', 1.0, 'DefaultLineLineWidth', 1.5);

cd cvx
cvx_setup
cd ../

fig_num = 4;

%% waypoint design

ds = 0.3;
v0 = 1.0;
a0 = 0.0;
vend = 0.0;
aend = 0.0;
omega = 1000;


path.s = 0:ds:50;
path.v = ones(size(path.s)) * 5.0;
path.v(70:100) =7.0;
path.v(100:130) = (linspace(7, 2, 101))';
path.v(400:end) = 2.0;

figure(fig_num);subplot(2,1,1);plot(path.s, path.v); grid on;
xlabel('x [m]'); ylabel('v [m/s]');

N = length(path.v);




tic

%%
% cvx model
cvx_begin
variables a(N) b(N)
JS = 0;
JV = 0;
for i = 1:N-1
    JS = JS + (a(i+1) - a(i))^2 / ds;
    JV = JV + abs(b(i) - path.v(i)^2) * ds;
end
minimize(JV + omega * JS)


% constraint
for i = 1:N-1
    (b(i+1) - b(i)) / ds == 2 * a(i);
end

for i = 1:N
    b(i) <= path.v(i)^2;
    b(i) >= 0.0;
end

% boundary condition
b(1) == v0^2;
b(end) == vend^2;
a(1) == a0;
a(end) == 0.0;

cvx_end

% answer

% optimization status
cvx_status

% final cost value
cvx_optval


%%
path_opt.s = path.s;
path_opt.v = sqrt(b);


figure(fig_num);subplot(2,1,1); hold on;
plot(path_opt.s, path_opt.v); 
plot(path.s(1), v0, 'o', path.s(end), vend, 'o');
legend('max', 'opt', 'initial condition', 'end conditon');
title_jerk_weight = strcat('jerk weight = ', num2str(omega, 3));
title(title_jerk_weight);


% jerk calculation
path_opt.jerk = zeros(N, 1);
for i = 1:N-1
    a_prime = (a(i+1) - a(i)) / ds;
    path_opt.jerk(i) = a_prime * sqrt(b(i));
end

figure(fig_num);
subplot(2,1,2); plot(path.s, path_opt.jerk); grid on;
legend('jerk');
ylabel('jerk [m/s3]')

toc