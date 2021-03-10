clear
clc
close all
format long

rocket.mass_init = 41.996;
rocket.mass_final = 30;
g = 9.81

%at time zero
rocket.vel = 0;
rocket.thrust = 1000;
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
rocket.cd = 0.6;
rocket.sref = 0.02;
rocket.delta_v = rocket.isp*g*log(rocket.mass_init/rocket.mass_final)
rocket.burn_time = rocket.mass_init*rocket.isp*g/rocket.thrust*(1-exp(-rocket.delta_v/(rocket.isp*g)))
rocket.mass_flow = 0.507;
for i = 0:step:maxT
    [~,~,~,rho] = atmosisa(rocket.alt);
    rocket.drag = 0.5*rho*rocket.vel^2*rocket.cd*rocket.sref;
    rocket.vel = rocket.vel + (rocket.thrust-(rocket.mass*g)-rocket.drag)*step/rocket.mass;
    rocket.res = (rocket.thrust-(rocket.mass*g)-rocket.drag)/rocket.mass;
    rocket.alt = rocket.alt + rocket.vel*step;
    if rocket.mass <= rocket.mass_final
        rocket.thrust = 0;
    else
        rocket.mass = rocket.mass - (rocket.mass_init-rocket.mass_final)*rocket.mass_flow*step;
    end
    alt = [alt rocket.alt];
    vel = [vel rocket.vel];
    time = [time i];
    mass = [mass rocket.mass];
    res = [res rocket.res];
    if rocket.alt < 0
        break
    end
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
ylabel('Resultant force (N)')
%xlim([0 maxT])
grid
title('Resultant force (N)')