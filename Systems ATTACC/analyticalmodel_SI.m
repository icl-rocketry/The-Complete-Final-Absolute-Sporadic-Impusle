clear
clc
close all
format long
rocket.mass_init = 41.996;
rocket.mass_final =30;
g = 9.81;
%at time zero
rocket.vel = 0;
rocket.isp = 180;
rocket.alt = 0;
step = 0.001;
time = 0;
rocket.mass = rocket.mass_init;
maxT = 40;
alt = [];
time = [];
vel = [];
mass = [];
res = [];
mach = [];
drag = [];
hybrid_burn_time = 15;
rocket.cd = 0.6;
rocket.sref = 0.0201;
rocket.mass_flow = 1000/(g*rocket.isp);
booster = readmatrix('K250Curve.csv');
hybrid = readmatrix('HybridCurve.csv');
x = linspace(0,maxT,maxT/step);
y = 2.*interp1(booster(:,1),booster(:,2),x);
y(isnan(y)== 1) = 0;
hybrid = interp1(hybrid(:,1),hybrid(:,2),x);
hybrid(isnan(hybrid)== 1) = 0;
rocket.thrust = (hybrid + y);
for i = step:step:maxT
    [~,a,~,rho] = atmosisa(rocket.alt);
    rocket.mach = rocket.vel/a;
    rocket.drag = (0.5.*rho.*rocket.vel.^2.*rocket.cd.*rocket.sref)/(1-rocket.mach^2);
    rocket.res = (rocket.thrust(round(i/step))-(rocket.mass*g)-rocket.drag)/rocket.mass;
    rocket.vel = rocket.vel + rocket.res*step;
    rocket.alt = rocket.alt + rocket.vel*step;
    if rocket.mass >= rocket.mass_final
        rocket.mass = rocket.mass - rocket.mass_flow*step;
    end
    alt = [alt rocket.alt];
    vel = [vel rocket.vel];
    time = [time i];
    mass = [mass rocket.mass];
    res = [res rocket.res];
    mach = [mach rocket.mach];
    drag = [drag rocket.drag];
end
subplot(2,2,1)
plot(time,alt)
xlabel('Time (s)')
ylabel('Altitude (m)')
%xlim([0 maxT])
title('Altitude vs Time')
grid
subplot(2,2,2)
plot(time,vel)
xlabel('Time (s)')
ylabel('Velocity (m s^-1)')
%xlim([0 maxT])
grid
title('Velocity vs Time')
subplot(2,2,3)
plot(time,res)
xlabel('Time (s)')
ylabel('Resultant acceleration (ms-2)')
%xlim([0 maxT])
grid
title('Resultant acceleration (ms-2)')
subplot(2,2,4)
plot(time,mach)
title('Mach number')
xlabel('Time (s)')
ylabel('Mach number')
grid
% figure
% plot(time,mass)
% title('Mass')
% xlabel('Time (s)')
% ylabel('Mass (kg)')
% grid