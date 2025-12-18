load ('out/scan_dac_0000.mat');

plot(vs+500, ve(:,1), '.-');
xline(0, 'k-', 'LineWidth', 1);  % Vertical line at x=0
yline(0, 'k-', 'LineWidth', 1);  % Horizontal line at y=0
xlabel('DAC code [1]');
ylabel('U_{dac} [V]');
grid on
hold on
