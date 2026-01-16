clear;

wpscans = [];

dtStart = char(datetime(2026, 01, 16, 21, 30, 0), 'yyyy-MM-dd HH:mm');
dtFinish = char(datetime(2026, 01, 16, 22, 10, 0), 'yyyy-MM-dd HH:mm');
basePath = 'out/';

sqlQuery = fileread('get_archive_mysql.sql');
 
query = sprintf(sqlQuery, dtStart, dtFinish);

conn = mysql('osarch', '1lid2a7r', 'Server', '172.16.19.177', 'DatabaseName', 'fmu1s', 'PortNumber',3306);
rundata = fetch(conn, query);
close(conn);
rundata.timestamp = datetime(rundata.timestamp);

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
legend({"T1", "T2", "T3"}, 'Location', 'best');

response = input('Save this shit as new run? (y/n): ', 's');

if lower(response) == 'y'
    [~, path] = createOutputFolder(basePath, 'run', 'pp');
    save(sprintf('%s/rundata.mat', path), 'rundata', 'wpscans');
    kbd2file(sprintf('%s/readme.txt', path), 'Enter description: ', true);
else
    disp('Saving cancelled.');
end

