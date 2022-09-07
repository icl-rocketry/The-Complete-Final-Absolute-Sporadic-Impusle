clear; clc; close all

filename = 'sensor_data.csv';
data = readtable(filename);

data.Properties.VariableNames = {'1','2','3','4','5','6',...
    '7','8','9','10','11','12','thrust','14','time'};

range = 158952:159572;
time = data.time(range);
thrust = -(data.thrust(range)-7146.3)./90436;

figure()
plot(time-min(time),thrust,LineWidth=1.25)

% scaled to 2kN
thrust_scaled = (thrust./max(thrust)).*2000;
time_scaled = (time-min(time))./1000;

figure()
plot(time_scaled,thrust_scaled,LineWidth=1.25)

% write scaled data to a file that doesn't work with openrocket :')
A = [time_scaled'; thrust_scaled'];

fileID = fopen('thrust.txt','w');
fprintf(fileID,'%6s %12s\n','time (s)','thrust (N)');
fprintf(fileID,'%6.2f %12.2f\n',A);
fclose(fileID);

% [min_time, index] = min(abs(time-TIME_U_WANT))