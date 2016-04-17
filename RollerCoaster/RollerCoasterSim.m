%%Generates track curve and estimates normal force experienced along track.

%%Constants
g = 9.81;           %gravitational constant, m/s^2
m_cart = 100;       %cart + rider mass, kg
h_start = 6.7056;        %Ramp starting height, m
l_end = 32;             %Track length

%Track Geometry Constants
b = .055;     %1/damping time constant
w = .7;     %angular frequency
p = .3;     %phase shift

coulomb_drag = 50;    %coulomb drag, N


%%

%%function that defines path shape
path_x = linspace(0, 23, 1000);
path_y = (exp(-b*path_x).*(cos(w*path_x - p)) + 2.2*(exp(-(b)*path_x)));
path_y = path_y*(h_start/max(path_y));
path_x = path_x*(l_end/max(path_x));
%%



initial_energy = m_cart*h_start*g;


%t = 1.42;               %time interval for generating parametric clothoid
%thetas = linspace(0, t, 1000);  

%r = cos(thetas)+2;

%x = 5.*(cos(thetas) + thetas./3) +4;
%y = 5.*(sin(thetas.)+1);

%x = zeros(length(thetas), 1);
%y = zeros(length(thetas), 1);

%for n = 2:length(thetas)            %generate half of clothoid
%    x(n) = x(n-1) + (cos((pi*thetas(n)^2)/2))*t/1000;
%    y(n) = y(n-1) + (sin((pi*thetas(n)^2)/2))*t/1000;
%end

%unscaled_height = max(y)



%x_loop = (h_loop/unscaled_height)*[x;fliplr((-1.*x)')'+2*x(end)];       %combine clothoid halves, scale by constant

%y_loop = (h_loop/unscaled_height)*[y;fliplr(y')'];

%x_loop = 5.*(cos(thetas) + thetas./2) +4;
%y_loop = 3.*(sin(thetas)+1);

%r = 3.5;


%angle = -pi/2:.01:3*pi/2;
%x_circle = r*cos(angle);
%y_circle = r*sin(angle);


%path = [linspace(0,h_start/2,100)', linspace(h_start,0,100)'];        %Ramp
%path = [path;[linspace(h_start/2,h_start/2+.5, 30)', zeros(30, 1)]];     %Flat before Loop
%path = [path;[x_loop+h_start/2+.5, y_loop]];                           %Loop



path = [path_x;path_y]';


%path = [0 1;1 0;0 -1;-1 0];
path_x = path(:,1);
path_y = path(:,2);

%path_x = linspace(0, 25, 1000);
%path_y = a*(exp(-b*t).*(cos(w*t - .4)) + exp(-b*t));

%%
%stuff for drag losses
shift_path_x = [path_x(2:end);path_x(end)];             %for calculating energy loss from drag
shift_path_y = [path_y(2:end);path_y(end)];

distance_change = ((path_x-shift_path_x).^2 + (path_y-shift_path_y).^2).^.5
total_distance = cumsum(distance_change);

loss = total_distance*coulomb_drag;
energy = initial_energy - loss;
potential_energy = m_cart*g*path_y;
kinetic_energy = energy - potential_energy;

speed = (2*kinetic_energy/m_cart).^.5;          %velocity using coulomb friction
%%
slope = zeros(length(path), 1);                %Initialize slope
curve_radius = zeros(length(path), 1);         %Initialize curve radius

%speed = ((-path_y + path_y(1)).*(2*g)).^.5;     %velocity using conservation of energy (friction ignored)


inverted = zeros(length(path),1);               %initialize inversion check

for n = 1:length(path)-1
    slope(n+1) = (path(n+1, 2)-path(n, 2))/(path(n+1, 1) - path(n, 1));         %Calculate slope at each point (rise/run)
    inverted(n) = (path_x(n+1) - path_x(n))/(norm(path_x(n+1) - path_x(n)));    %determine if inverted (moving backwards)
end

slope(1) = slope(2);                %Fix exceptions for first/last points
inverted(length(slope)) = inverted(length(slope)-1);

theta = atan(slope);    %angle at given point



for n = 2:length(path)-1        %Calculate radius of curviature at given point by circle curcumscribed about 3 points
    a = sqrt((path_x(n) - path_x(n-1))^2 + (path_y(n) - path_y(n-1))^2);
    b = sqrt((path_x(n) - path_x(n+1))^2 + (path_y(n) - path_y(n+1))^2);
    c = sqrt((path_x(n+1) - path_x(n-1))^2 + (path_y(n+1) - path_y(n-1))^2);
    
    curve_radius(n) = (a*b*c)/(sqrt((a^2+b^2+c^2)^2 - 2*(a^4+b^4+c^4)));   
end

concavity = zeros(length(path), 1); %whether the track is curving out or in

for n = 2:length(path)-1
    concavity(n) = ((path_y(n+1)-path_y(n))/(path_x(n+1)-path_x(n)))-((path_y(n) - path_y(n-1))/(path_x(n) - path_x(n-1)));
    concavity(n) = concavity(n)/(abs(concavity(n)));
end

concavity(1) = concavity(2);
concavity(end) = concavity(end-1);

curve_radius(1) = curve_radius(2);      %Fix exceptions for first and last points
curve_radius(length(path)) = curve_radius(length(path)-1);
curve_radius = curve_radius.*concavity;

centripetal_a = (speed.^2)./(curve_radius);     %calculate centripetal acceleration from radius of curvature and velocity
centripetal_f = m_cart*centripetal_a;           %calculate centripetal force from mass and acceleration

gravity_normal = m_cart*g.*cos(theta).*inverted;    %Calculate component of normal force between track and cart due to gravity

normal_force = gravity_normal + centripetal_f;      %Calculate total normal force between cart and track
gees = normal_force./(g*m_cart);                    %Calculate 'G-force' - normal force normalized by mass

[Ax, H1, H2] = plotyy(path_x, path_y, path_x, gees);       %Plot roller coaster track, G-force experienced along path

xlabel('X (m)');
ylabel(Ax(1), 'Y (m)');
ylabel(Ax(2),'Gs');
axis equal;             %Scale axes so track is proportional.
