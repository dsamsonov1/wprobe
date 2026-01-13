scanNumber = 23; % Номер набора результатов для отображения
basePath = 'out/';

[resFolder,~] = findOutputFolder(basePath, 'scan', 'dd', scanNumber);
load (sprintf('%s/scandata.mat', resFolder));

plot(vs+500, (ve(:,1)*100)-vs-500, '.-');
xline(0, 'k-', 'LineWidth', 1);  % Vertical line at x=0
yline(0, 'k-', 'LineWidth', 1);  % Horizontal line at y=0
xlabel('DAC code [1]');
ylabel('U_{dac} [V]');
grid on
hold on

f1 = fit(vs+500, (ve(:,1)*100)-vs-500,  'cubicspline');

ff1 = feval(f1, vs+500);

%plot(vs+500, ff1, '.-');

cf.correction = uint16(feval(f1, vs+500)*65536/1000);

%uint16(a_v*65536/1000+32767)
