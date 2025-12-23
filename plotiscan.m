% Рисуем картинку для скана с внешним амперметром.

scanNumber = 24; % Номер набора результатов для отображения
basePath = 'out/';

[resFolder,~] = findOutputFolder(basePath, 'scan', 'vv', scanNumber);
load (sprintf('%s/scandata.mat', resFolder));

if isempty(ie)
    error('В наборе данных нет данных с внешнего амперметра.');
end

f1 = fit(double(ie(:,1)), double(ii),  'poly1');
ifit = feval(f1, ie(:,1));

fprintf('Iadc(Iext) = %.3e*Iext + %.3e\n', f1.p1, f1.p2);

subplot(2, 2, 1);
yyaxis left;
plot(ie(:,1), ii, '.-', ie(:,1), ifit, '-r');
ylim([1.1*min(ii) 1.1*max(ii)])
xline(0, 'k-', 'LineWidth', 1);  % Vertical line at x=0
yline(0, 'k-', 'LineWidth', 1);  % Horizontal line at y=0
xlabel('I_{ext} [A]');
ylabel('I_{adc} [A]');
grid on

yyaxis right;
plot(ie(:,1), rr, '.');
yticklabels({'', '1: 10 нА', '2: 100 нА', '3: 1 мкА', '4: 10 мкА', '5: 100 мкА', '6: 1 мА', ''});
ylim([0 7]);
%ylabel('№ предела');


%%%%%

di = ie(:,1)-ii;

f2 = fit(ie(:,1), double(di),  'poly1');
ifit = feval(f2, ie(:,1));

subplot(2, 2, 3);
plot(ie(:,1), di, '.-', ie(:,1), ifit, '-r');
xlabel('I_{ext} [A]');
ylabel('I_{ext}-I_{adc} [A]');
grid on

subplot(2, 2, [2 4]);
errorbar(ie(:,1), ie(:,2), ie(:,1)-ie(:,4), ie(:,3)-ie(:,1), 'LineStyle', 'none', 'Color', [0.6 0.3 0.1]);
hold on
plot (ie(:,1), ie(:,2), '.', 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue');
xlabel('I_{ext} [A]');
ylabel('std(I_{ext}) [A]');
grid on