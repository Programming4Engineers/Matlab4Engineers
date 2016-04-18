function [] = motion_trajectory( vo , ao, ho, n)

    addpath('functions');

    % -------------------------- Parametros Iniciais --------------------------
    g = -9.809;      % [m/s^2]   Aceleração da gravidade
    so = 0;

    syms t;
    
    % Componentes da velocida
    vox = vo*cos(ao*pi/180);
    voy = vo*sin(ao*pi/180);
    
    
    % Distância máxima 
    tmax = bhaskara(g/2, voy, ho);
    
    array_t = 0:tmax/n:tmax;                        % Vetor de tempo
    array_h = ho + voy.*array_t + g.*array_t.^2/2;  % Vetor contem a altura
    array_s = so + vox.*array_t;
    array_vx = max(array_s)/max(array_t);
    array_vy = voy + g.*array_t;                    % Vetor contem a velocidade

    hold on;
    subplot(2,3,4);
    plot(array_t, array_h, 'b .','markers',12);
    plot(array_t, array_s, 'r .','markers',12);
        max_y = max ( max(array_h), max(array_s));
        axis([0 round(max(array_t)) 0 round(max_y)]);
        title('Posição');

    subplot(2,3,5);
    plot(array_t, array_vx, 'b .','markers',12);
    plot(array_t, array_vy, 'r .','markers',12);
        max_y = max( max(array_vx), max(array_vy) );
        min_y = min( min(array_vx), min(array_vy) );
        axis([0 round(max(array_t)) round(min_y) round(max_y)]);
        title('Velocidade');

    subplot(2,3,6);
    plot(array_t, g, 'b .','markers',12);
    plot(array_t, 0, 'r .','markers',12);
        axis([0 max(array_t) -10 10]);
        title('Aceleração');

    extents = [min(array_s) max(array_s)+0.25 min(array_h) max(array_h)+0.25];
    time = 0;
    tic;
    while time < array_t(end)
        subplot(2,3,[1 2 3]);
        
        posxDraw = interp1(array_t,array_s',time')';
        posyDraw = interp1(array_t,array_h',time')';
        
        % Redraw the image
        drawProjectile(time, posxDraw, posyDraw, extents);

        % Update current time
        time = toc;
    end
end


