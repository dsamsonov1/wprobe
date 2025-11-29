clear m;
m = modbus('serialrtu', 'COM2');
m.Timeout = 3;

% Save the Server ID specified.
adcId = 51;
didoId = 52;
dacId = 50;
ptime = 0.75;

rm = [10e-9 100e-9 1e-6 10e-6 100e-6 1e-3];

ii = [];
rr = [];
vv = [];

write(m, "coils", 17, [0 0 0 0 0 1], didoId);
write(m, "coils", 23, 1, didoId);

for i = 250:5:950
    write(m, 'holdingregs', 2049, i, dacId, 'uint16');
    pause(ptime)
    v0 = read(m, 'inputregs', 2, 1, adcId, 'uint16');
    [i0, r0] = readCurrent(m, didoId, adcId, rm);    
    pause(ptime)
    ii = [ii; i0];
    vv = [vv; v0-500];
    rr = [rr; r0];
end

write(m, 'holdingregs', 2049, 500, dacId, 'uint16');
write(m, "coils", 23, 0, didoId);
write(m, "coils", 17, [0 0 0 0 0 1], didoId);

clear m;

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

function result = bsign(x)
    result = 2*x - 1;
end

function [current, r0] = readCurrent(m, didoId, adcId, rm)

    waitTime = 0.75;

    cr = read(m, "coils", 17, 6, didoId);
    cri = find(cr);
    ovl = checkOvl(m, didoId);
    success = true;
    while ovl && success
        [success, cr] = selectRange(1, cri, cr);
        cri = find(cr);
        if success
            write(m, "coils", 17, cr, didoId);
            pause(waitTime);
            ovl = checkOvl(m, didoId);
        end
    end

    if ~success && ovl
        current = NaN;
        r0 = cri;
        return;
    end

    cc = read(m, 'inputregs', 1, 1, adcId, 'uint16');

    if cc <= 100
        success = true;
        while cc <= 100 && success
            [success, cr] = selectRange(0, cri, cr);
            cri = find(cr);
            if success
                write(m, "coils", 17, cr, didoId);
                pause(waitTime);
            end
            cc = read(m, 'inputregs', 1, 1, adcId, 'uint16');
        end
    end
    sign = read(m, "inputs", 9, 1, didoId);
    current = bsign(sign)*cc/1000*rm(cri);
    r0 = cri;
end