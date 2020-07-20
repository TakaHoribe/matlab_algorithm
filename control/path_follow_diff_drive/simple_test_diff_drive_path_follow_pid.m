clear variables;
close all;


set(0, 'defaultAxesFontSize', 12);
set(0, 'defaultTextFontSize', 20);
set(0, 'DefaultAxesLineWidth', 1.0, 'DefaultLineLineWidth', 1.0);


L = 0.2; % rotation-center to control point [m]
v = 0.1; % velocity on wheel-center[m/s]
gain_lat = 1.0;
gain_yaw = 1.0;

param(1) = L;
param(2) = v;
param(3) = gain_lat;
param(4) = gain_yaw;

lat_err_ini = 0.3; % [m]
yaw_err_ini = 0.2; %[rad]

x0_pp = [ lat_err_ini,  yaw_err_ini];
x0_pn = [ lat_err_ini, -yaw_err_ini];
x0_np = [-lat_err_ini,  yaw_err_ini];
x0_nn = [-lat_err_ini, -yaw_err_ini];

T = [0:0.01:100];


[~, X1] = ode45(@(t, y) f(t, y, param), T, x0_pp);
[~, X2] = ode45(@(t, y) f(t, y, param), T, x0_pn);
[~, X3] = ode45(@(t, y) f(t, y, param), T, x0_np);
[~, X4] = ode45(@(t, y) f(t, y, param), T, x0_nn);


figure(1); hold on;
plot(T, X1(:, 1), 'b', T, X1(:,2), 'r', 0, x0_pp(1), 'bo', 0, x0_pp(2), 'ro');
plot(T, X2(:, 1), 'b', T, X2(:,2), 'r', 0, x0_np(1), 'bo', 0, x0_np(2), 'ro');
plot(T, X3(:, 1), 'b', T, X3(:,2), 'r', 0, x0_pn(1), 'bo', 0, x0_pn(2), 'ro');
plot(T, X4(:, 1), 'b', T, X4(:,2), 'r', 0, x0_nn(1), 'bo', 0, x0_nn(2), 'ro');
xlabel("t [s]"); legend("lateral error [m]", "yaw error [rad]"); grid on;

function dx = f(t, x, param) 

L = param(1);
v = param(2);
gain_lat = param(3);
gain_yaw = param(4);

lat_err = x(1);
yaw_err = x(2);

% feedback control calculation
w = - sign(v) * gain_lat * lat_err - gain_yaw * yaw_err;


dy = v * sin(yaw_err) + L * cos(yaw_err) * w;
dyaw = w;

dx = [dy; dyaw];

end