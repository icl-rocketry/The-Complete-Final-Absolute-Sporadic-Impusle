% Houskeeping
clear
clc
close all
format long


% Define physical constants of the simulation

g = 9.81;
time_init = 0;
time_final = 40;
% time step for each loop
ts = 0.01;
% array holding all time steps
tSteps = time_init:ts:time_final;


% Define rocket constants

% initial rocket mass
mass_init = 41.996;
% final rocket mass
mass_final = 30; 

%at time 0

%RK4 Variable % extrapolating acceleration in order to get velocity
vel = 0; 
% isp from wiki
isp = 180;
% alt 0 at t=0
alt = 0;
cd = 1;
sref = 0.0201;
hybrid_burn_time = 15;
% Use equation for mass flow rate
mass = [mass_init];
%Takes thrust curves, returns variable holding total thrust over time
[thrust,thrust_h] = thrust_curve_maker('K250Curve.csv','HybridCurve.csv',time_final,ts);
y = zeros(2,time_final/ts+1);
% runge kutta step (number of points for rk step)
h = 0.01; 
y0 = [0,0]; % both x' and v' are 0 initially
y(:,1) = y0;
vel = [];
alt = [];
time = [];
mach = [];
res = [];
drag = [];
for i = 1:length(tSteps)-1 % for full time range
    % determine local speed of sound and density
%     if tSteps(i) < 0.744
%         mass_flow = thrust_h(i)/(g*isp)+(2*1.292)/0.744;
%     else
%         mass_flow = thrust_h(i)/(g*isp)
%     end
    mass_flow = thrust_h(i)/(g*isp);
    if i == 1
        [~,a,~,rho] = atmosisa(0);
    else
        [~,a,~,rho] = atmosisa(i);
    end
    % function needs to be redefined every loop due to changing constants
    % acceleration = resultant force/mass
    f = @(y,t,a,rho) [y(2);(thrust(i)-(mass(i)*g)-(0.5*rho*y(2)^2*cd*sref)./(1-(y(2)/a)^2))./mass(i)];
    res(end+1) = (thrust(i)-(mass(i)*g)-(0.5*rho*y(2,i)^2*cd*sref)./(1-(y(2,i)/a)^2))./mass(i);
    drag(end+1) = (0.5*rho*y(2,i)^2*cd*sref)./(1-(y(2,i)/a)^2);
    k1 = h*f(y(:,i),tSteps(i),a,rho); % interpolate once to get first point
    k2 = h*f(y(:,i) + k1/2, tSteps(i)+ h/2,a,rho); % interpolate using first point for k
    k3 = h*f(y(:,i) + k2/2, tSteps(i)+ h/2,a,rho); % interpolate using 2 preceeding for k
    k4 = h*f(y(:,i) + k3, tSteps(i)+ h,a,rho); % interpolate using 3 preceeding values for k
    y(:,i+1) = y(:,i) + k1/6 + k2/3 + k3/3 + k4/6; % gain next value of velocity (for next time step), log velocity in array
    vel(end+1) = y(2,i); % calculate altitude based on current velocity and time step
    alt(end+1) = y(1,i);
    time(end+1) = tSteps(i);
    if mass(i) >= mass_final
        mass(i+1) = mass(i) - mass_flow*ts;
    else
        disp('nofuel')
        mass(i+1) = mass(i);
    end
    mach(end+1)= y(2,i)/a;
end

% Plot graphs

subplot(2,3,1) % plot as appropriate
plot(time,alt)
xlabel('Time (s)')
ylabel('Altitude (m)')
title('Altitude vs Time')
grid
subplot(2,3,2)
plot(time,vel)
xlabel('Time (s)')
ylabel('Velocity (m s^-1)')
grid
title('Velocity vs Time')
subplot(2,3,3)
plot(time,res)
xlabel('Time (s)')
ylabel('Resultant acceleration (ms-2)')
grid
title('Resultant acceleration (ms-2)')
subplot(2,3,4)
plot(time,mach)
title('Mach number')
xlabel('Time (s)')
ylabel('Mach number')
grid
subplot(2,3,5)
plot(time,mass(1:end-1))
title('Mass')
xlabel('Time (s)')
ylabel('Mass (kg)')
grid
subplot(2,3,6)
plot(time,drag)
title('Drag')
xlabel('Time (s)')
ylabel('Drag (N)')
grid