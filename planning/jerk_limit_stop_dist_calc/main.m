set(0, 'defaultAxesFontSize', 12);
set(0, 'defaultTextFontSize', 20);
set(0, 'DefaultAxesLineWidth', 1.0, 'DefaultLineLineWidth', 1.5);

a_arr = 1:-1:-1;
% a_arr = 0;
for a0 = a_arr

%% parameter definition
% jerk constraint
s = 1.5;

% initial condition
kmph2mps = 1 / 3.6;
v0 = 10.0 * kmph2mps; % [m/s]
% a0 = -2.0; % [m/s2]

%% calculate trajectory parameters

% calculate -s time
t2 = sqrt(v0 / s + 0.5 * a0^2 / s^2);

% calculate -s time
t1 = t2 + a0 / s;
T = t1 + t2;

if (t1 < 0 || t2 < 0)
    s = -s;
    % calculate -s time
    t2 = sqrt(v0 / s + 0.5 * a0^2 / s^2);

    % calculate -s time
    t1 = t2 + a0 / s;
    T = t1 + t2;
end

% calculate t1 end point condition
x1 = -s * t1^3 / 6 + a0 * t1^2 / 2 + v0 * t1;
v1 = -s * t1^2 / 2 + a0 * t1 + v0;
a1 = -s * t1 + a0;

x2 = s * t2^3 / 6 + a1 * t2^2 / 2 + v1 * t2 + x1;

%% calculate time series data
tarr = 0:0.01:T;
xt = zeros(length(tarr), 1);
vt = zeros(length(tarr), 1);
at = zeros(length(tarr), 1);
st = zeros(length(tarr), 1);
for i = 1:length(tarr)
    xt(i) = func_xt(s, a0, v0, t1, t2, tarr(i));
    vt(i) = func_vt(s, a0, v0, t1, t2, tarr(i));
    at(i) = func_at(s, a0, v0, t1, t2, tarr(i));
    st(i) = func_st(s, a0, v0, t1, t2, tarr(i));
end

tmp1 = strcat("initial condition : v0 = ", num2str(v0), "[m/s], a0 = ", num2str(a0), "[m/s2], jerk = ", num2str(s), "[m/s3]");
tmp2 = strcat("result : T = ", num2str(T), "[s], x(T) = ", num2str(xt(end)), "[m]");
% title_string = strcat(tmp1, " \n ", tmp2);
title_string = [tmp1, tmp2];

% figure;
% subplot(4,1,1); plot(tarr, xt); legend('x [m]'); ylabel('x [m]'); grid on; 
% title(title_string);
% subplot(4,1,2); plot(tarr, vt); legend('v [m/s]'); ylabel('v [m/s]'); grid on;
% subplot(4,1,3); plot(tarr, at); legend('a [m/s2]'); ylabel('a [m/s2]'); grid on;
% subplot(4,1,4); plot(tarr, st); legend('s [m/s3]'); ylabel('s [m/s3]'); grid on;
% xlabel('t [s]');

    fprintf('v0 = %3.3f [km/h], a0 = %3.3f [m/ss], T = %3.3f [s],  x(T) = %3.3f [m]\n', v0 / kmph2mps, a0, T, xt(end));



end
%% functions
function xt = func_xt(s, a0, v0, t1, t2, t)
    xt = 0;
    if (0 <= t && t <= t1)
        xt = -s * t^3 / 6 + a0 * t^2 / 2 + v0 * t;
    elseif (t1 < t && t <= t1 + t2)
        x1 = -s * t1^3 / 6 + a0 * t1^2 / 2 + v0 * t1;
        v1 = -s * t1^2 / 2 + a0 * t1 + v0;
        a1 = -s * t1 + a0;
        t_tmp = t - t1;
        xt = s * t_tmp^3 / 6 + a1 * t_tmp^2 / 2 + v1 * t_tmp + x1;
    end
end

function vt = func_vt(s, a0, v0, t1, t2, t)
    vt = 0;
    if (0 <= t && t <= t1)
        vt = -s * t^2 / 2 + a0 * t + v0;
    elseif (t1 < t && t <= t1 + t2)
        v1 = -s * t1^2 / 2 + a0 * t1 + v0;
        a1 = -s * t1 + a0;
        t_tmp = t - t1;
        vt = s * t_tmp^2 / 2 + a1 * t_tmp + v1;
    end
end

function at = func_at(s, a0, v0, t1, t2, t)
    at = 0;
    if (0 <= t && t <= t1)
        at = -s * t + a0;
    elseif (t1 < t && t <= t1 + t2)
        a1 = -s * t1 + a0;
        t_tmp = t - t1;
        at = s * t_tmp + a1;
    end
end

function st = func_st(s, a0, v0, t1, t2, t)
    st = 0;
    if (0 <= t && t <= t1)
        st = -s;
    elseif (t1 < t && t <= t1 + t2)
        st = s;
    end
end
