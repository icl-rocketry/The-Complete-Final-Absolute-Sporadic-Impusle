% Maximising Rocket Altitude 

% housekeeping
clear
clc
close all


% Constants
g = 9.81;               % gravity (m/s^2)   
c1 = 1700;              %
tb1 = 14.4;
T1 = 900;
I_t1 = T1*tb1;
isp1 = I_t1/(7*g);
A = 0.0212;
Cd = 0.57;
rho = 1.225;
k = 0.5*1.225*A*Cd;
M_01 = 46.586; % hybrid engine without boosters, kg


% Initialise heigth and dry mass as symbols
syms h t

dMdt = -T1/c1;
M = M_01 - (T1/(g*isp1))*t;
M_d = double(subs(M, t, tb1)); % dry mass, kg
dvdt = -g + T1/M;

% vb1 = c1*log(M_01/M)-g*tb1;

vb1 = int(dvdt, 0, tb1);
h1 = int(vb1, 0, tb1);

vc = -sqrt((M_d*g)/k)*tan(sqrt((g*k)/M_d)*t - atan(sqrt(k/(M_d*g))*vb1));
tc = double(sqrt((M_d*g)/k)*atan(sqrt(k/(M_d*g))*vb1));
hc = int(vc, 0, tc);

syms v(t)

ode(t) = diff(v, t) == -g-(k*v^2)/M_d;
cond = v(0) == vb1;
vSol(t) = dsolve(ode) == 0;
S = solve(vSol);

% h1a = (((M*c1^2)*log(M/M_01))/T1) + c1*tb1 - 0.5*g*tb1^2;
% h1b = (M/(2*k))*log(1+((k*vb1^2)/(g*M)));

% h1a = ((c1^2*M*tb1)/I_t1)*log((M*c1)/(M*c1+I_t1)) + c1*tb1 + ...
%     (M/(2*k))*log(1+((k*vb1^2)/(g*M))) - 0.5*g*tb1^2;

% Dev's fancy-looking equation thingy
% h1 = ((c1^2)*M*tb1)/(I_t1)*log((M*c1)/(M*c1+I_t1)) + ... 
%     c1*tb1 + (M/(2*k))*log(1+(k/(M*g))*(g*tb1 - c1*log(1+I_t1/(M*c1)))^2) - ...
%     (g*tb1^2)/2;

% Boosters
% c2 = 1935.7;
% tb2 = 3.98;
% T2 = 602*2;
% I_t2 = 2415*2;
% M_02 = 34.791; % wet mass, without hybrid engine, with boosters, kg
% 
% % vb2 = c2*log(M_02/M)-g*tb2;
% 
% % h2a = (((M*c2^2)*log(M/M_02))/T2) + c2*tb2 - 0.5*g*tb2^2 + ...
% % (M/(2*k))*log(1+((k*vb2^2)/(g*M)));
% 
% % h2a = ((c2^2*M*tb2)/I_t2)*log((M*c2)/(M*c2+I_t2)) + c2*tb2 + ...
% %     (M/(2*k))*log(1+((k*vb2^2)/(g*M))) - 0.5*g*tb2^2;
% 
% h2 = ((c2^2)*M*tb2)/(I_t2)*log((M*c2)/(M*c2+I_t2)) + ... 
%     c2*tb2 + (M/(2*k))*log(1+(k/(M*g))*(g*tb2 - c2*log(1+I_t2/(M*c2)))^2) - ...
%     (g*tb2^2)/2;
% 
% h = h1 + h2;

% figure
% fplot(h1a,[0 100]);
% hold on;
% fplot(h1b, [0 100]);
% xlabel('Dry Mass (kg)','Interpreter','latex')
% ylabel('Height (m)','Interpreter','latex')
% % ylim([0, 5000]);
% grid on
% box on





