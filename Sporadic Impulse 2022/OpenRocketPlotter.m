% this script should, if ive done it right, plot all the data we need from
% openrocket so we dont need to always make new scripts to plot data for
% reprts and design reviews and stuff

clear; clc; close all

% read data from csv file 
% SELECT and export all 54 variables from openrocket 
% UNSELECT all comments (simulation descriptions, field descriptions and
% flight events)

filename = '';
data = readtable(filename);

data.Properties.VariableNames = {'time','altitude','vert_vel','vert_acc','tot_vel',...
    'tot_acc','pos_east','pos_north','lat_dist','lat_dir','lat_vel','lat_acc','latitude',...
    'longitude','grav_acc','aoa','roll_rate','pitch_rate','yaw_rate','mass','prop_mass',...
    'longitudinal_moment_of_inertia','rotational_moment_of_inertia','cp','cg','stability margin',...
    'mach','re','thrust','drag','cd','axial_cd','friction_cd','pressure_cd','base_cd',...
    'normal_force_coeff','pitch_moment_coeff','yaw_moment_coeff','side_force_coeff',...
    'roll_moment_coeff','roll_forcing_coeff','roll_damping_coeff','pitch_damping_coeff',...
    'coriolis_coeff','ref_length','ref_area,','zenith','azimuth','v_wind','air_temp',...
    'pressure_air','speed_of_sound','simulation_step_time','computation_time'};

% trajectory plots
figure()
yyaxis right
plot(data.time,data.altitude,'-k','LineWidth',1.2);
hold on
ylabel('Altitude (m)','Interpreter','latex');
yyaxis left
plot(data.time,data.vert_vel,'-r','LineWidth',1.2);
plot(data.time,data.vert_acc, '-g', 'LineWidth',1.2);
xlabel('Time (s)','Interpreter','latex');
ylabel('Vertical Velocity (m/s), Vertical Acceleration (m/s$^$2)','Interpreter','latex');
legend({'Vertical Velocity','Vertical Acceleration','Altitude'},'Location','northeast','Interpreter','latex');
box on;
grid on;
hold off

% ground track plots
figure();
subplot(1,2,1)
plot(data.pos_east, data.altitude,'-k','LineWidth',1.2);
xlabel('Position East of Launch Pad (m)','Interpreter','latex');
ylabel('Altitude (m)','Interpreter','latex');
subplot(1,2,2)
plot(data.pos_east, data.pos_north, '-k','LineWidth',1.2);
xlabel('Position East of Launch Pad (m)','Interpreter','latex');
ylabel('Position North of Launch Pad (m)','Interpreter','latex');
box on;
grid on;

% stability plots
figure();
yyaxis right
plot(data.time, data,'-k','LineWidth',1);
hold on
ylabel('Stability Margin (cal)','Interpreter','latex');
yyaxis left
plot(data.time, data.cg, '-r', 'LineWidth',1);
plot(data.time, data.cp, '-g', 'LineWidth',1);
xlabel('Time (s)','Interpreter',"latex");
ylabel('Centre of Gravity (cm), Centre of Pressure (cm)','Interpreter','latex');
legend({'Centre of Gravity','Centre of Pressure','Stability Margin'},'Location','southeast','Interpreter','latex');
box on;
grid on;
hold off