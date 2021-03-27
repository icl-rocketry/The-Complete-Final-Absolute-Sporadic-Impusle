function [thrust,hybrid_thrust] = thrust_curve_maker(booster_curve,hybrid_curve,t_f,step)
%THRUST_CURVE_MAKER Summary of this function goes here
%   Takes csv files as inputs and returns 
%Takes thrust curves, returns variable holding total thrust over time
booster = readmatrix(booster_curve); % data from aerotech booster
hybrid = readmatrix(hybrid_curve); % thurst curve provided
x = linspace(0,t_f,t_f/step); % remove 0 values
y = 2.*interp1(booster(:,1),booster(:,2),x);
y(isnan(y)== 1) = 0;
hybrid = interp1(hybrid(:,1),hybrid(:,2),x);
hybrid(isnan(hybrid)== 1) = 0;
thrust = (hybrid + y);
hybrid_thrust = hybrid;
end

