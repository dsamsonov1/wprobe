% Рисуем картинку для скана с внешним вольтметром.
% По скану, снятому на эталонном резисторе, можно оценить качество
% измерителей

scanNumber = 14; % Номер набора результатов для отображения
basePath = 'out/';

[resFolder,~] = findOutputFolder(basePath, 'scan', 'vv', scanNumber);
load (sprintf('%s/scandata.mat', resFolder));

if isempty(ve)
    error('В наборе данных нет данных с внешнего вольтметра.');
end

f1 = fit(double(ve(:,1)), double(vv),  'poly1');
vfit = feval(f1, ve(:,1));

fprintf('Uadc(Uext) = %.4f*Uext%+.4f\n', f1.p1, f1.p2);

subplot(2, 3, 1);
plot(ve(:,1), vv, '.-', ve(:,1), vv, '-r');
xline(0, 'k-', 'LineWidth', 1);  % Vertical line at x=0
yline(0, 'k-', 'LineWidth', 1);  % Horizontal line at y=0
xlabel('U_{ext} [V]');
ylabel('U_{adc} [V]');
grid on

subplot(2, 3, 4);
plot(ve(:,1), ve(:,1)-vv, '.-');
xlabel('U_{ext} [V]');
ylabel('U_{ext}-U_{adc} [V]');
grid on

f2 = fit(double(vs), double(vv),  'poly1');
vfit = feval(f2, vs);

fprintf('Uadc(Uset) = %.4f*Uset%+.4f\n', f2.p1, f2.p2);

subplot(2, 3, 2);
plot(vs, vv, '.-', vs, vs, '-');
xline(0, 'k-', 'LineWidth', 1);  % Vertical line at x=0
yline(0, 'k-', 'LineWidth', 1);  % Horizontal line at y=0
ylabel('U_{adc} [V]');
xlabel('U_{set} [V]');
grid on

subplot(2, 3, 5);
plot(vs, vv-vs, '.-');
ylabel('U_{adc}-U_{set} [V]');
xlabel('U_{set} [V]');
grid on

subplot(2, 3, [3 6]);
errorbar(ve(:,1), ve(:,2), ve(:,1)-ve(:,4), ve(:,3)-ve(:,1), 'LineStyle', 'none', 'Color', [0.6 0.3 0.1]);
hold on
plot (ve(:,1), ve(:,2), '.', 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue');
xlabel('U_{ext} [V]');
ylabel('std(U_{ext}) [V]');
grid on