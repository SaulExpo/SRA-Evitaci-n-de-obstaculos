function ShowTrajectory(filename)
% IN:
%   filename - log filename [char]
% OUT:
%   figure?
% EXAMPLE:
%   ShowTrajectory('my_log2025_12_07_20_40_19.log')

    [path, obs] = ExtractPathScans(filename, 0);

    % Calcular velocidades
    v_lin = sqrt(path.vx.^2 + path.vy.^2);
    v_ang = path.vth;

    % Calcular aceleraciones
    dt = diff(path.time);
    dt(dt < 1e-6) = 1e-6;

    acc_lin = diff(v_lin) ./ dt;
    acc_ang = diff(v_ang) ./ dt;

    % Ajustar vectores de tiempo
    time_vel = path.time - path.time(1);
    time_acc = time_vel(1:end-1);

    % Calcular distancia al obstáculo más cercano
    min_dist = zeros(1, length(path.time));
    for i = 1:length(path.time)
        if i <= length(obs.x) && ~isempty(obs.x{i})
            dx = obs.x{i} - path.x(i);
            dy = obs.y{i} - path.y(i);
            dists = sqrt(dx.^2 + dy.^2);
            min_dist(i) = min(dists);
        else
            min_dist(i) = NaN;
        end
    end

    % 1. Crear figura con fondo
    % Colores: NEGRO ('k'), CIAN ('c'), ROJO ('c'), VERDE ('g'), BLANCO ('w')
    figure('Name', ['Analisis Completo: ' filename], 'Color', 'k');

    % Subplot 1: Velocidad Lineal
    subplot(5,1,1);
    plot(time_vel, v_lin, 'c', 'LineWidth', 1.5);
    ylabel('V. Lineal (m/s)');
    title('Velocidad Lineal');
    grid on;

    % Subplot 2: Aceleración Lineal
    subplot(5,1,2);
    plot(time_acc, acc_lin, 'c');
    ylabel('Acel. Lineal (m/s^2)');
    title('Aceleración Lineal');
    grid on;

    % Subplot 3: Velocidad Angular
    subplot(5,1,3);
    plot(time_vel, v_ang, 'r', 'LineWidth', 1.5);
    ylabel('V. Angular (rad/s)');
    title('Velocidad Angular');
    grid on;

    % Subplot 4: Aceleración Angular
    subplot(5,1,4);
    plot(time_acc, acc_ang, 'r');
    ylabel('Acel. Angular (rad/s^2)');
    title('Aceleración Angular');
    grid on;

    % Subplot 5: Distancia a Obstáculos
    subplot(5,1,5);
    plot(time_vel, min_dist, 'g', 'LineWidth', 1.5);
    ylabel('Distancia (m)');
    xlabel('Tiempo (s)');
    title('Distancia al Obstáculo más Cercano');
    yline(0.3, '--w', 'Radio Robot');
    grid on;

    % Cambiar todos los ejes a blanco
    all_axes = findall(gcf, 'type', 'axes');
    set(all_axes, 'Color', 'k', 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
end
