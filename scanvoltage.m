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

vv = [];
ve = [];
vi = [];

setHVState(0, m, didoId, waitTime);
setCurrentRange([0 0 0 0 1 0], m, didoId, waitTime);
setVoltage(0, m, dacId, ptime);

setHVState(1, m, didoId, waitTime);

for i = -500:20:500
    setVoltage(i, m, dacId, ptime);
    v0 = read(m, 'inputregs', 2, 1, adcId, 'uint16');
    vi0 = input(sprintf('Input indicated voltage (Vs=%d): ', i));
    ve0 = vo.writeread('MEAS:VOLT:DC?');
    ve = [ve; str2double(ve0)];
    vv = [vv; v0-500];
    vi = [vi; vi0];
end

setVoltage(0, m, dacId, ptime);
setHVState(0, m, didoId, waitTime);
setCurrentRange([0 0 0 0 1 0], m, didoId, waitTime);

clear m;
clear vo;

%save('out/vscan_0000.mat', "vi", "ve", "vv");
