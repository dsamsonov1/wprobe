% Рисуем картинку ВАХ по данным АЦП тока и напряжения
% По ВАХ, снятой на эталонном резисторе, можно оценить качество
% измерителей

scanNumber = 24; % Номер набора результатов для отображения
basePath = 'out/';

[resFolder,~] = findOutputFolder(basePath, 'scan', 'vv', scanNumber);
load (sprintf('%s/scandata.mat', resFolder));

f1 = fit(double(vv), double(ii),  'poly1');
ifit = feval(f1, vv);

fprintf('Iadc(Uadc) = %.4e*Uadc%+.4e\n', f1.p1, f1.p2);

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
yticks([0 1 2 3 4 5 6 7]);
yticklabels({'', '1: 10 нА', '2: 100 нА', '3: 1 мкА', '4: 10 мкА', '5: 100 мкА', '6: 1 мА', ''});
ylabel('№ предела');
set(gca, 'FontName', 'Arial');

fprintf('Rext: Meas=%.0f [Ohm] - вычисленное по ВАХ\n', 1/f1.p1);
if isfield(cf, 'Rext')
    fprintf('Rext: Set =%.0f [Ohm] - заданное снаружи эталонное значение\nОтклонение Rext: %.4f%%\n', cf.Rext, 1/f1.p1/cf.Rext/100);
end

exportgraphics(gcf, sprintf('%s/plotchar.pdf', resFolder));