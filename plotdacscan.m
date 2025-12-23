scanNumber = 24; % Номер набора результатов для отображения
basePath = 'out/';

[resFolder,~] = findOutputFolder(basePath, 'scan', 'vv', scanNumber);
load (sprintf('%s/scandata.mat', resFolder));

plot(vs+500, ve(:,1), '.-');
xline(0, 'k-', 'LineWidth', 1);  % Vertical line at x=0
yline(0, 'k-', 'LineWidth', 1);  % Horizontal line at y=0
xlabel('DAC code [1]');
ylabel('U_{dac} [V]');
grid on
hold on
