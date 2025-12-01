if exist('m', 'var')
    clear m;
end
if exist('vo', 'var')
    clear vo;
end

m = modbus('serialrtu', 'COM2');
m.Timeout = 3;

extV = true;
address = '172.16.19.62';

if extV
    vo = visadev(sprintf('tcpip0::%s::instr', address));
end

% Save the Server ID specified.
adcId = 51;
didoId = 52;
dacId = 50;
ptime = 0.75;
waitTime = 0.75;

rm = [10e-9 100e-9 1e-6 10e-6 100e-6 1e-3];

ii = [];
rr = [];
vv = [];
ve = [];
vs = [];

if ~getMbState(m, didoId)
    error('Device must be in MODBUS mode.');
end

setVoltage(0, m, dacId, waitTime);
setHVState(0, m, didoId, waitTime);
setCurrentRange([0 0 0 0 1 0], m, didoId, waitTime);

setHVState(1, m, didoId, waitTime);

for vset = -250:5:250
    setVoltage(vset, m, dacId, waitTime);
    v0 = getADCVoltage(m, adcId);
    [i0, r0] = readCurrent(m, didoId, adcId, rm, waitTime);    
    if extV
        ve0 = vo.writeread('MEAS:VOLT:DC?');
        ve = [ve; ve0];
    end
    ii = [ii; i0];
    vv = [vv; v0];
    rr = [rr; r0];
    vs = [vs; vset];
    pause(ptime)
end

setVoltage(0, m, dacId, waitTime);
setHVState(0, m, didoId, waitTime);
setCurrentRange([0 0 0 0 1 0], m, didoId, waitTime);

clear m;
clear vo;

%save('out/iscan_0000.mat', "vs", "rr", "vv", "ii", "ve", "waitTime", "ptime");
