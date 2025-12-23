% Рисуем картинку ВАХ по данным АЦП тока и напряжения

scanNumber = 24; % Номер набора результатов для отображения
basePath = 'out/';

[resFolder,~] = findOutputFolder(basePath, 'scan', 'vv', scanNumber);
load (sprintf('%s/scandata.mat', resFolder));

f1 = fit(double(vv), double(ii),  'poly1');

ifit = feval(f1, vv);

%subplot(2, 2, 1);
yyaxis left;
plot(vv, ii, '.-', vv, ifit, '-r');

xline(0, 'k-', 'LineWidth', 1);  % Vertical line at x=0
yline(0, 'k-', 'LineWidth', 1);  % Horizontal line at y=0
xlabel('U_{adc} [V]');
ylabel('I_{adc} [A]');
grid on

yyaxis right;
plot(vv, rr, '.');
ylim([0 7]);
yticklabels({'', '1: 10 нА', '2: 100 нА', '3: 1 мкА', '4: 10 мкА', '5: 100 мкА', '6: 1 мА', ''});
ylabel('№ предела');

fprintf('Rext: Calc=%.0f [Ohm]\n', 1/f1.p1);
if isfield(cf, 'Rext')
    fprintf('Rext: Meas=%.0f [Ohm]; Tol = %.4f%%\n\n', cf.Rext, 1/f1.p1/cf.Rext/100);
end

