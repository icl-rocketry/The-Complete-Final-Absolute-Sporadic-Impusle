% this script should, if ive got variable names right, plot all the data we need from
% openrocket so we dont need to always make new scripts to plot data for
% reports nd design reviews nd stuff
% update: so it doesn't plot all the data (because im too lazy to
% pre-generate a bunch of plots) but it does plot the kinda useful stuff
% like trajectory, ground track and stability. The rest of the variables
% are put into a nice-ish table for u to use if u ever need them though
% ive no clue why we'd need some of them

% --- please remember to move this somewhere nice on the git !!! ---

clear; clc; close all

% read data from csv file 
% SELECT and export all 54 variables from openrocket 
% UNSELECT all comments (simulation descriptions, field descriptions and
% flight events)

filename = 'data.csv';
data = readtable(filename);

data.Properties.VariableNames = {'time','altitude','vert_vel','vert_acc','tot_vel',...
    'tot_acc','pos_east','pos_north','lat_dist','lat_dir','lat_vel','lat_acc','latitude',...
    'longitude','grav_acc','aoa','roll_rate','pitch_rate','yaw_rate','mass','prop_mass',...
    'longitudinal_moment_of_inertia','rotational_moment_of_inertia','cp','cg','stability_margin',...
    'mach','re','thrust','drag','cd','axial_cd','friction_cd','pressure_cd','base_cd',...
    'normal_force_coeff','pitch_moment_coeff','yaw_moment_coeff','side_force_coeff',...
    'roll_moment_coeff','roll_forcing_coeff','roll_damping_coeff','pitch_damping_coeff',...
    'coriolis_coeff','ref_length','ref_area,','zenith','azimuth','v_wind','air_temp',...
    'pressure_air','speed_of_sound','simulation_step_time','computation_time'};

% trajectory plots
figure()
yyaxis right
plot(data.time,data.altitude,'-k','LineWidth',1.5);
hold on
ylabel('Altitude (m)','Interpreter','latex','FontSize',14);
yyaxis left
plot(data.time,data.vert_vel,'-r','LineWidth',1.5);
plot(data.time,data.vert_acc, '-b', 'LineWidth',1.5);
xlabel('Time (s)','Interpreter','latex','FontSize',14);
ylabel('Vertical Velocity (m/s), Vertical Acceleration (m/s$^2$)','Interpreter','latex','FontSize',14);
legend({'Vertical Velocity','Vertical Acceleration','Altitude'},'Location','northeast','Interpreter','latex','FontSize',14);
box on;
grid on;
hold off

% 3d plot
figure()
yyaxis right
plot(data.time,data.altitude,'-k','LineWidth',1.5);
hold on
ylabel('Altitude (m)','Interpreter','latex','FontSize',14);
yyaxis left
plot(data.time,data.vert_vel,'-r','LineWidth',1.5);
plot(data.time,data.vert_acc, '-b', 'LineWidth',1.5);
xlabel('Time (s)','Interpreter','latex','FontSize',14);
ylabel('Vertical Velocity (m/s), Vertical Acceleration (m/s$^2$)','Interpreter','latex','FontSize',14);
legend({'Vertical Velocity','Vertical Acceleration','Altitude'},'Location','northeast','Interpreter','latex','FontSize',14);
box on;
grid on;
hold off

% ground track plots
figure();
subplot(1,2,1)
plot(data.pos_east, data.altitude,'-k','LineWidth',2);
xlabel('Position East of Launch Pad (m)','Interpreter','latex','FontSize',14);
ylabel('Altitude (m)','Interpreter','latex','FontSize',14);
box on;
grid on;
subplot(1,2,2)
plot(data.pos_east, data.pos_north, '-k','LineWidth',2);
xlabel('Position East of Launch Pad (m)','Interpreter','latex','FontSize',14);
ylabel('Position North of Launch Pad (m)','Interpreter','latex','FontSize',14);
box on;
grid on;

% stability plots
figure();
yyaxis right
plot(data.time, data.stability_margin,'-r','LineWidth',1.5);
hold on
ylabel('Stability Margin (cal)','Interpreter','latex','FontSize',14);
yyaxis left
plot(data.time, data.cg, '-k', 'LineWidth',1.5);
plot(data.time, data.cp, '-b', 'LineWidth',1.5);
xlabel('Time (s)','Interpreter','latex','FontSize',14);
ylabel('Centre of Gravity (cm), Centre of Pressure (cm)','Interpreter','latex','FontSize',14);
legend({'Centre of Gravity','Centre of Pressure','Stability Margin'},'Location','southeast','Interpreter','latex','FontSize',11);
box on;
grid on;
hold off