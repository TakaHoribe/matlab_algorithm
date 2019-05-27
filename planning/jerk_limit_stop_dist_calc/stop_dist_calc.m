function x = stop_dist_calc(v0, a0, s)

% calculate -s time
t2 = sqrt(v0 / s + 0.5 * a0^2 / s^2);

% calculate -s time
t1 = t2 + a0 / s;

if (t1 < 0 || t2 < 0)
    s = -s;
    t2 = sqrt(v0 / s + 0.5 * a0^2 / s^2); % calculate -s time    
    t1 = t2 + a0 / s; % calculate -s time
end

% calculate t1 end point condition
x1 = -s * t1^3 / 6 + a0 * t1^2 / 2 + v0 * t1;
v1 = -s * t1^2 / 2 + a0 * t1 + v0;
a1 = -s * t1 + a0;

x = s * t2^3 / 6 + a1 * t2^2 / 2 + v1 * t2 + x1;

end