function [] = motion_trajectory( vo , ao, ho, n)

    addpath('functions');

    % -------------------------- Parametros Iniciais --------------------------
    g = -9.809;      % [m/s^2]   Acelera��o da gravidade
    so = 0;

    syms t;
    
    % Componentes da velocida
    vox = vo*cos(ao*pi/180);
    voy = vo*sin(ao*pi/180);
    
    % Altura m�xima
    hmax = ho - 1.5*voy*voy/g;
    
    % Dist�ncia m�xima 
    tmax = bhaskara(g/2, voy, ho);
    
    smax = so + vox*tmax;
    
    array_t = 0:tmax/n:tmax;                           % Vetor de tempo
    array_h = ho + voy.*array_t + g.*array_t.^2/2;   % Vetor contem a altura
    array_s = so + vox.*array_t;
    array_vx = max(array_s)/max(array_t);
    array_vy = voy + g.*array_t;                      % Vetor contem a velocidade

    figure(1);
    for i=1:length(array_t)

        subplot(3,3,[1 2 4 5 7 8]);
        plot(array_s(i), array_h(i), 'k o');
        axis([min(array_s) max(array_s) min(array_h) max(array_h)+1]);
        title(['LAN�AMENTO DE PROJ�TIL ---- Tempo de simula��o: ' num2str(array_t(i),2) ' s']);
        drawnow;

        hold on
        subplot(3,3,3);
        plot(array_t(i), array_h(i), 'b .','markers',12);
        plot(array_t(i), array_s(i), 'r .','markers',12);
        max_y = max ( max(array_h), max(array_s));
        axis([0 round(max(array_t)) 0 round(max_y)]);
        title('Posi��o');
        drawnow;

        hold on
        subplot(3,3,6);
        plot(array_t(i), array_vx, 'b .','markers',12);
        plot(array_t(i), array_vy(i), 'r .','markers',12);
        max_y = max( max(array_vx), max(array_vy) );
        min_y = min( min(array_vx), min(array_vy) );
        axis([0 round(max(array_t)) round(min_y) round(max_y)]);
        title('Velocidade');
        drawnow;

        hold on
        subplot(3,3,9);
        plot(array_t(i), g, 'b .','markers',12);
        plot(array_t(i), 0, 'r .','markers',12);
        axis([0 max(array_t) -10 10]);
        title('Acelera��o');
        drawnow;
        hold on
        pause(1/60);
    end
end

