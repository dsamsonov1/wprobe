runNumber = 4;
basePath = 'out/';

[resFolder,~] = findOutputFolder(basePath, 'run', 'pp', runNumber);
load (sprintf('%s/rundata.mat', resFolder));

tstamp = rundata.timestamp - rundata.timestamp(1);

t = tiledlayout(5, 1, 'TileSpacing', 'tight', 'Padding', 'compact');

nexttile;
yyaxis left
plot(tstamp, rundata.p);
yscale log
ylabel('p [Pa]');
yyaxis right;
plot(tstamp, rundata.f);
ylabel('f [MHz]');
xticks([])
grid on

nexttile;
yyaxis left;
plot(tstamp, rundata.urf)
ylabel('U_{rf} [V]');
yyaxis right;
plot(tstamp, rundata.ub)
ylabel('U_{b} [V]');
grid on
xticks([])

nexttile;
plot(tstamp, rundata.pf)
ylabel('P_{f} [W]');
grid on
xticks([])

nexttile;
yyaxis left
plot(tstamp, rundata.pr)
ylabel('P_{r} [W]');
yyaxis right
plot(tstamp, rundata.pf-rundata.pr)
ylabel('P_{f}-P_{r} [W]');
grid on

nexttile;
plot(tstamp, rundata.t1, 'r-', tstamp, rundata.t2, 'g-', tstamp, rundata.t3, 'b-');
ylabel('T [degC]');
grid on
ylim([0 100]);
legend({"T1", "T2", "T3"}, 'Location', 'best')

exportgraphics(gcf, sprintf('%s/runplot.pdf', resFolder), "Resolution", 600);

writetable (rundata, sprintf('%s/run.csv',resFolder), ...
    'Delimiter', ',', ...           % Comma delimiter (default)
    'WriteVariableNames', true, ... % Include header (default)
    'QuoteStrings', true, ...       % Quote strings if needed
    'Encoding', 'UTF-8');           % Specify encoding