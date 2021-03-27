function [t,y] = RungeKutta4(f,tspan,y0,h)
% Fourth-order Runge-Kutta

m = length(y0);
t = tspan(1):h:tspan(2);
y = zeros(m,length(t));
y(:,1) = y0;

for i = 1:length(t)-1
    k1 = h*f(t(i),y(:,i));
    k2 = h*f(t(i)+h/2,y(:,i)+k1/2);
    k3 = h*f(t(i)+h/2,y(:,i)+k2/2);
    k4 = h*f(t(i)+h,y(:,i)+k3);
    y(:,i+1) = y(:,i) + k1/6 + (k2+k3)/3 + k4/6;
end