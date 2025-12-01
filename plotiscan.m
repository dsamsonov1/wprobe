load('out/iscan_0000.mat');

yyaxis left;
plot(vv, ii, '.-')
xline(0, 'k-', 'LineWidth', 1);  % Vertical line at x=0
yline(0, 'k-', 'LineWidth', 1);  % Horizontal line at y=0
xlabel('U [V]');
ylabel('I [A]');
yyaxis right;
plot(vv, rr, '.');
ylim([0 7]);
yticks([1 2 3 4 5 6])
ylabel('№ предела');
grid on
