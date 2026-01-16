% Рисуем картинку ВАХ по данным АЦП тока и напряжения
% По ВАХ, снятой на эталонном резисторе, можно оценить качество
% измерителей

%scanNumbers = [42 49 50 51 52]; % Номера наборов результатов для отображения
%scanNumbers = [56 57 60]; % Номера наборов результатов для отображения
%scanNumbers = [65 66 67 68 69 70 71 72 73 74 75 76 77 78]; % Номера наборов результатов для отображения
%dtStart = char(datetime(2025, 12, 29, 11, 00, 0);
%scanNumbers = [115 116 118 119 120 123 124 125 126 127 128 129 131 132 134 135 136 137 138 139]; % Номера наборов результатов для отображения

basePath = 'out/';

runId = 3;

if exist("runId")
    [runFolder,~] = findOutputFolder(basePath, 'run', 'pp', runId);
    load(sprintf('%s/rundata.mat', runFolder));
    scanNumbers = wpscans;
    dtStart = rundata.timestamp(1);
end

invertVoltage = false;   % Обратить полярность напряжения
invertCurrent = true;   % Обратить полярность тока

v = {};
i = {};

for j = scanNumbers
    [resFolder,~] = findOutputFolder(basePath, 'scan', 'vv', j);
    load (sprintf('%s/scandata.mat', resFolder));
    fprintf('#%d: %s\n', j, char(scantimestamp-dtStart));
    if invertVoltage
        vv = -vv;
    end
    if invertCurrent
        ii = -ii;
    end
   
    v{end+1} = vv;
    i{end+1} = ii;

    writematrix([vv ii], sprintf('%s/scan_%d.csv', runFolder, j));
end

figure;

hold on
for j = 1:numel(scanNumbers)
    plot(v{:,j}, i{:,j}, '.-');
end
hold off

xline(0, 'k-', 'LineWidth', 1);  % Vertical line at x=0
yline(0, 'k-', 'LineWidth', 1);  % Horizontal line at y=0

%xlim(1.1.*[min{v} max{v}]);
%ylim(1.1.*[min{i} max{i}]);
xlabel('U_{adc} [V]');
ylabel('I_{adc} [A]');
legend(arrayfun(@(i) sprintf('#%d', i), scanNumbers, ...
    'UniformOutput', false), 'NumColumns', 2);
grid on

%exportgraphics(gcf, sprintf('%s/plotchar.pdf', resFolder));