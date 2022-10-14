%% 
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

filename = 'frr6.csv';
data = readtable(filename);

% u may need to chnage variable names here cus im stupid and made some
% random variables like dynamic pressure in openrocket
data.Properties.VariableNames = {'time','altitude','vert_vel','vert_acc','tot_vel',...
    'tot_acc','pos_east','pos_north','lat_dist','lat_dir','lat_vel','lat_acc','latitude',...
    'longitude','grav_acc','aoa','roll_rate','pitch_rate','yaw_rate','mass','prop_mass',...
    'longitudinal_moment_of_inertia','rotational_moment_of_inertia','cp','cg','stability_margin',...
    'mach','re','thrust','drag','cd','axial_cd','friction_cd','pressure_cd','base_cd',...
    'normal_force_coeff','pitch_moment_coeff','yaw_moment_coeff','side_force_coeff',...
    'roll_moment_coeff','roll_forcing_coeff','roll_damping_coeff','pitch_damping_coeff',...
    'coriolis_coeff','ref_length','ref_area,','zenith','azimuth','v_wind','air_temp',...
    'pressure_air','speed_of_sound','simulation_step_time','computation_time','dynamic pressure'};

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
apogee = max(data.altitude);
ind = find(data.altitude == apogee,1);
pos_east_apogee = data.pos_east(ind);
pos_north_apogee = data.pos_north(ind);
landing_altitude = data.altitude(find(data.altitude==0,1));

figure()
traj = plot3(data.pos_east,data.pos_north,data.altitude,'-b','LineWidth',1.5);
hold on
launch_site = plot3(0,0,0,'r.','MarkerSize',24);
hold on
landing_zone = plot3(data.pos_east(end),data.pos_north(end),landing_altitude,'g.','MarkerSize',24);
hold on 
apogee_point = plot3(pos_east_apogee,pos_north_apogee,apogee,'k.','MarkerSize',24);
hold off
xlabel('Position East of Launch Pad (m)','Interpreter','latex','FontSize',14);
ylabel('Position North of Launch Pad (m)','Interpreter','latex','FontSize',14);
zlabel('Altitude (m)','Interpreter','latex','FontSize',14)
legend([launch_site, landing_zone, apogee_point],{'Launch Pad','Touchdown','Apogee'},'Interpreter','latex','FontSize',12)
zlim([0 inf])
box on;
grid on;
% axis equal;

% ground track plots
figure();
subplot(1,2,1)
plot(data.pos_east, data.altitude,'-k','LineWidth',2);
hold on
launch_site = plot(0,0,'r.','MarkerSize',24);
hold on
landing_zone = plot(data.pos_east(end),landing_altitude,'g.','MarkerSize',24);
hold off
xlabel('Position East of Launch Pad (m)','Interpreter','latex','FontSize',14);
ylabel('Altitude (m)','Interpreter','latex','FontSize',14);
legend([launch_site, landing_zone],{'Launch Pad','Touchdown'},'Interpreter','latex','FontSize',12)
box on;
grid on;

subplot(1,2,2)
plot(data.pos_east, data.pos_north, '-k','LineWidth',2);
hold on
launch_site = plot(0,0,'r.','MarkerSize',24);
hold on
landing_zone = plot(data.pos_east(end),data.pos_north(end),'g.','MarkerSize',24);
xlabel('Position East of Launch Pad (m)','Interpreter','latex','FontSize',14);
ylabel('Position North of Launch Pad (m)','Interpreter','latex','FontSize',14);
legend([launch_site, landing_zone],{'Launch Pad','Touchdown'},'Interpreter','latex','FontSize',12)
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

% % landing zone plot with 95% confidence ellipse
% pos_east = [1:500]';
% pos_north = [1:500]';
% 
% data = [pos_east pos_north];
% 
% % Calculate the eigenvectors and eigenvalues
% covariance = cov(data);
% [eigenvec, eigenval ] = eig(covariance);
% 
% % Get the index of the largest eigenvector
% [largest_eigenvec_ind_c, r] = find(eigenval == max(max(eigenval)));
% largest_eigenvec = eigenvec(:, largest_eigenvec_ind_c);
% 
% % Get the largest eigenvalue
% largest_eigenval = max(max(eigenval));
% 
% % Get the smallest eigenvector and eigenvalue
% if(largest_eigenvec_ind_c == 1)
%     smallest_eigenval = max(eigenval(:,2));
%     smallest_eigenvec = eigenvec(:,2);
% else
%     smallest_eigenval = max(eigenval(:,1));
%     smallest_eigenvec = eigenvec(1,:);
% end
% 
% % Calculate the angle between the x-axis and the largest eigenvector
% angle = atan2(largest_eigenvec(2), largest_eigenvec(1));
% 
% % This angle is between -pi and pi.
% % shift so the angle is between 0 and 2pi
% if(angle < 0)
%     angle = angle + 2*pi;
% end
% 
% % Get the coordinates of the data mean
% avg = mean(data);
% 
% % Get the 95% confidence interval error ellipse
% chisquare_val = 2.4477;
% theta_grid = linspace(0,2*pi);
% phi = angle;
% X0=avg(1);
% Y0=avg(2);
% a=chisquare_val*sqrt(largest_eigenval);
% b=chisquare_val*sqrt(smallest_eigenval);
% 
% % the ellipse in x and y coordinates 
% ellipse_x_r  = a*cos( theta_grid );
% ellipse_y_r  = b*sin( theta_grid );
% 
% %Define a rotation matrix
% R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ];
% 
% %rotate the ellipse to some angle phi
% r_ellipse = [ellipse_x_r;ellipse_y_r]' * R;
% 
% figure();
% plot(pos_east,pos_north,'b.','MarkerSize',24)
% hold on 
% confellipse = plot(r_ellipse(:,1) + X0,r_ellipse(:,2) + Y0,'r-',LineWidth=2);
% launch_site = plot(0,0,'g.','MarkerSize',24);
% hold off
% xlabel('Position East of Launch Pad (m)','Interpreter','latex','FontSize',14);
% ylabel('Position North of Launch Pad (m)','Interpreter','latex','FontSize',14);
% legend([confellipse, launch_site],{'95\% Confidence Ellipse','Launch Pad'},'Interpreter','latex','FontSize',12)

