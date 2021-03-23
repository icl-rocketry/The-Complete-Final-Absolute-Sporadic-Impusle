%clearing
clear
clc
clf

x0 = 10;
omega = 500;
ti = 0;
tf = 20;
h = 0.5;
tSteps = ti:h:tf;

xSteps(1) = x0;
xSteps(length(tSteps)) = 0;

f = @(x,t) -x + sin(omega*t);

for i = 1:length(tSteps)-1
    xSteps(i+1) = xSteps(i) + h*f(xSteps(i), tSteps(i));
end

figure(1)
hold on
plot(tSteps, xSteps, 'bo--')

xRunge(1) = x0;
xRunge(length(tSteps)) = 0;

for i = 1:length(tSteps)-1
    k1 = h*f(xRunge(i), tSteps(i));
    k2 = h*f(xRunge(i) + k1/2, tSteps(i) + h/2);
    k3 = h*f(xRunge(i) + k2/2, tSteps(i) + h/2);
    k4 = h*f(xRunge(i) + k3, tSteps(i) + h);
    xRunge(i+1) = xRunge(i) + k1/6 + k2/3 + k3/3 + k4/6;
end

plot(tSteps, xRunge, 'rx--')
legend