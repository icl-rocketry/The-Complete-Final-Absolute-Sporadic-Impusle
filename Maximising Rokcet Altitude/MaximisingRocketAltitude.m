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
A = 0.0212;
Cd = 0.57;
rho = 1.225;
k = 0.5*1.225*A*Cd;

% Initialise heigth and dry mass as symbols
syms h M

% Dev's fancy-looking equation thingy
h1 = (c1^2*M*tb1)/(I_t1)*log((M*c1)/(M*c1+I_t1)) + ... 
    c1*tb1 + (M/(2*k))*log(1+(k/(M*g))*(g*tb1 - c1*log(1+I_t1/(M*c1)))^2) - ...
    g*tb1^2/2;

% Boosters
c2 = 1935.7;
tb2 = 3.98;
T2 = 602*2;
I_t2 = 2415*2;

h2 = (c2^2*M*tb2)/(I_t2)*log((M*c2)/(M*c2+I_t2)) + ... 
    c2*tb2 + (M/(2*k))*log(1+(k/(M*g))*(g*tb2 - c2*log(1+I_t2/(M*c2)))^2) - ...
    g*tb2^2/2;

h = h1 + h2;

figure
fplot(h2,[0 100])
xlabel('Dry Mass (kg)','Interpreter','latex')
ylabel('Height (m)','Interpreter','latex')
grid on
box on





