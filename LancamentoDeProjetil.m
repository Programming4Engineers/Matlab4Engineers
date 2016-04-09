% -------------------- Simulação de Objetos Abandonados ------------------- 
% 
% Relações Importantes:
%       v = vo + at
%       s = so + vot + at^2/2
% 

close all, clear all

% -------------------------- Parametros Iniciais --------------------------
g = 9.809;      % [m/s^2]   Aceleração da gravidade


ho = input('Altura Inicial');       % [m]       ALtura inicial
vo = 0;         % [m/s]     Velocidade Inicial

t = sqrt(2*(-ho)/(-g));

array_t = 0:0.1:t;                  % Vetor de tempo
array_h = 100 - g.*array_t.^2/2;    % Vetor contem a altura
array_v = vo + g.*array_t;

figure(1);
for i=1:length(array_t)
    
      
    subplot(3,3,[1 2 4 5 7 8]);
    plot(0, array_h(i), 'k o');
    axis([-1 1 0 ho]);
    title(['LANÇAMENTO DE PROJÉTIL ---- Tempo de simulação: ' num2str(array_t(i),2) ' s']);
    drawnow;
    
    hold on
    subplot(3,3,3);
    plot(array_t(i), array_h(i), 'b .','markers',12);
    axis([0 max(array_t) 0 max(array_h)]);
    title('Posição');
    drawnow;
    
    hold on
    subplot(3,3,6);
    plot(array_t(i), array_v(i), 'b .','markers',12);
    axis([0 max(array_t) 0 max(array_v)]);
    title('Velocidade');
    drawnow;
    
    hold on
    subplot(3,3,9);
    plot(array_t(i), g, 'b .','markers',12);
    title('Aceleração');
    drawnow;
    hold on
    pause(1/60);
end
