clear cf;

cf.extV = true;             % Измеряем ли напряжение внешним вольтметром?
cf.manV = false;            % Измеряем ли напряжение индикатора на панели (ручной ввод)?
cf.acquireCurrent = true;   % Измеряем ли ток?

cf.verboseLevel = 0;

cf.vmin = -490;
cf.vmax = 490;
cf.vstep = 10;

cf.ptime = 0.3;             % Время ожидания после установки напряжения смещения
cf.waitTime = 0.3;          % Время ожидания после коммутации реле (пределы, HV)
cf.samplesCount = 3;

vrange = cf.vmin:cf.vstep:cf.vmax;

%cf.adcId = 51;
cf.adcId = 1;
cf.didoId = 52;
cf.dacId = 50;
cf.ADC_voltage_reg = 3;
cf.ADC_current_reg = 1;

cf.vo_address = '172.16.19.62'; % Адрес внешнего вольтметра
cf.mbport = 'COM2';

cf.m = modbus('serialrtu', cf.mbport);
cf.m.Timeout = 3;

if ~getMbState(cf)
    error('Device must be in MODBUS mode.');
end

if cf.extV
    cf.vo = visadev(sprintf('tcpip0::%s::instr', cf.vo_address));
    cf.vo.Timeout = 3;
end

% Save the Server ID specified.

vv = []; % Напряжение по АЦП
ve = []; % Напряжение по внешнему вольтметру
vi = []; % Напряжение по индикатору на панели
vt = []; % Развертка по времени внешнего вольтметра
vs = []; % Уставка ЦАП по напряжению
ii = []; % Измеренные токи
rr = []; % Пределы измерения при которых измерялись токи

setHVState(0, cf);
setCurrentRange([0 0 0 0 1 0], cf);
setVoltage(0, cf)
setHVState(1, cf);

for i = vrange
    verbosePrint("-- Starting voltage step %d [V].", 0, cf.verboseLevel, i);
    setVoltage(i, cf);
    v0 = getADCVoltage(cf);
    if cf.manV
        vi0 = input(sprintf('Input indicated voltage (Vs=%d): ', i));
        vi = [vi; vi0];
    end
    if cf.acquireCurrent
        [i0, r0] = readCurrent(cf);
        rr = [rr; r0];
        ii = [ii; i0];
    end
    if cf.extV
        vt0 = strrep(cf.vo.writeread(sprintf('CONF:VOLT:DC AUTO;:SAMP:COUN %d;:CALC:AVER:STAT ON;:INIT;:FETC?', cf.samplesCount)), newline, '');
        ve0 = strrep(cf.vo.writeread('CALC:AVER:ALL?;:CALC:AVER:COUNT?'), newline, '');
        ve = [ve; str2double(split(ve0, {',', ';'}))'];
    end
    vt = [vt; str2double(split(vt0, {',', ';'}))'];
    vv = [vv; v0];
    vs = [vs; i];
    verbosePrint("-- Voltage step %d [V] finished.", 1, cf.verboseLevel, i);
end

setVoltage(0, cf);
setHVState(0, cf);
setCurrentRange([0 0 0 0 1 0], cf);

if isfield(cf, 'm')
    cf = rmfield(cf, 'm');
end
if isfield(cf, 'vo')
    cf = rmfield(cf, 'vo');
end

[~, path] = createOutputFolder('out/', 'scan', 'vv');
save(sprintf('%s/scandata.mat', path), "vi", "ve", "vv", "vs", "vt", "cf");
kbd2file(sprintf('%s/readme.txt', path), 'Enter description: ', false);

disp('All done. Take a beer!');
