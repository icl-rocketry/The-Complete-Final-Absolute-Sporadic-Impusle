% Maximising Rocket Altitude 

% housekeeping
clear
clc
close all


% Constants
g = 9.81;               % gravity (m/s^2)   
c1 = 1700;              % Exhaust velocity
tb1 = 14.4; %Burn time
T1 = 900; %Thrust
I_t1 = T1*tb1; %Total impulse
isp1 = I_t1/(7*g);
A = 0.0212; %Frontal area!
Cd = 0.57;
rho = 1.225;
k = 0.5*1.225*A*Cd; %Drag parameter thing
M_01 = 46.586; % hybrid engine without boosters, kg


% Initialise heigth and dry mass as symbols
syms v t

dMdt = -T1/c1;
M = M_01 - (T1/(g*isp1))*t;
M_d = double(subs(M, t, tb1)); % dry mass, kg
%This is just the model that ignores drag to get a velocity at the end of
%the burn. We can try something better later.
%dvdt = -g + T1/M;
dvdt = @(v,t) -g + T1/(M_01 - (T1/(g*isp1))*t);

%dvdtb = - g + T1/M -k*v^2/M; %Syms expression
dvdtb = @(v,t) - g + (T1 - k*v^2) / (M_01 - (T1/(g*isp1))*t); %ODE45 expression

%The Syms Approach
%solves for height, velocity at the end of the burn.
%vb1 = int(dvdt, 0, tb1);
%vb = int(dvdtb,t);
%h1 = int(vb,t);
%vb1 = solve(vb,v);
%vb1 = subs(vb1,t,tb1);
%vb1 = solve();
%h1 = double(h1);

%The ODE45 Approach
[tb,vb] = ode45(dvdtb,[0 tb1],0);
hb = trapz(tb,vb);
vb1 = vb(end);

%The eqn of motion during coast is M * v' = - Mg -kv^2
dvdtc = @(t,v) -g - k/M_d * v^2; %this is dv/dt during coast. 
tspan = [0 20]; %I'm putting in a random arbitrary number for tim   e. 

[t,v] = ode45(dvdtc, tspan,vb1);
check = v > 0;
v = v.*check;
hc = trapz(t,v);

htotal = hc + hb



