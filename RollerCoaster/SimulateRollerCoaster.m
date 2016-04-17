close all
clear 
clc

%%Constants
g = 9.81;           %gravitational constant, m/s^2
m_cart = 100;       %cart + rider mass, kg
h_start = 6.7056;        %Ramp starting height, m
l_end = 35;             %Track length

%Track Geometry Constants
b = .055;     %1/damping time constant
w = .7;     %angular frequency
p = .3;     %phase shift

coulomb_drag = 50;    %coulomb drag, N

path_x = linspace(0, 23, 1000);
path_y = (exp(-b*path_x).*(cos(w*path_x - p)) + 2.2*(exp(-(b)*path_x)));

path_y = path_y*(h_start/max(path_y));
path_x = path_x*(l_end/max(path_x));

% Initial Energy
initial_energy = m_cart*h_start*g;

path_x = path_x';
path_y = path_y';


% Stuff for drag losses
shift_path_x = [path_x(2:end);path_x(end)];             %for calculating energy loss from drag
shift_path_y = [path_y(2:end);path_y(end)];
distance_change = ((path_x-shift_path_x).^2 + (path_y-shift_path_y).^2).^.5;
total_distance = cumsum(distance_change);
loss = total_distance*coulomb_drag;

% Total Energy 
energy = initial_energy - loss;
potential_energy = m_cart*g*path_y;
kinetic_energy = energy - potential_energy;

% figure 
% plot(path_x, kinetic_energy);
% plot(path_x,potential_energy);
% 
% hold on
subplot(2,1,1)
plot(path_x,path_y);
hold on
h = plot(5,5,'bs','MarkerFaceColor',[0.5,0.5,0.5],...
                    'LineWidth',2,...
                    'MarkerSize',35,...
                   'YDataSource','Y',...
                   'XDataSource','X');

for i = 1:numel(path_x)
    X = path_x(i);
    Y = path_y(i)+0.10;
    refreshdata(h,'caller');
    subplot(2,1,2)
    bar([energy(i) loss(i);kinetic_energy(i) potential_energy(i)],'stacked')
    legend('Kinetic Energy','Potential Energy','Location','northeastoutside')
    drawnow;
    pause(.0005);
end