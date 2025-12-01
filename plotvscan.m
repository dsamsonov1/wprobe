load ('out/vscan_0000.mat');

plot(ve, vv, '.-', ve, vi, '.-');
xline(0, 'k-', 'LineWidth', 1);  % Vertical line at x=0
yline(0, 'k-', 'LineWidth', 1);  % Horizontal line at y=0
xlabel('U_{ext} [V]');
ylabel('U_{adc} [V], U_{ind} [V]');
grid on