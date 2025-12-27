% Рисуем картинку ВАХ по данным АЦП тока и напряжения
% По ВАХ, снятой на эталонном резисторе, можно оценить качество
% измерителей

%scanNumbers = [42 49 50 51 52]; % Номера наборов результатов для отображения
scanNumbers = [56 57 60]; % Номера наборов результатов для отображения
basePath = 'out/';

v = [];
i = [];

for j = scanNumbers
    [resFolder,~] = findOutputFolder(basePath, 'scan', 'vv', j);
    load (sprintf('%s/scandata.mat', resFolder));

    v = [v vv];
    i = [i ii];
end

figure;

hold on
for j = 1:numel(scanNumbers)
    plot(v(:,j), i(:,j), '.-');
end
hold off

xline(0, 'k-', 'LineWidth', 1);  % Vertical line at x=0
yline(0, 'k-', 'LineWidth', 1);  % Horizontal line at y=0

xlim(1.1.*[min(vv) max(vv)]);
ylim(1.1.*[min(ii) max(ii)]);
xlabel('U_{adc} [V]');
ylabel('I_{adc} [A]');
legend(arrayfun(@(i) sprintf('#%d', i), scanNumbers, ...
    'UniformOutput', false), 'NumColumns', 2);
grid on

%exportgraphics(gcf, sprintf('%s/plotchar.pdf', resFolder));