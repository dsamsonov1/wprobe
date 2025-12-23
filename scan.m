clear cf;

cf.extV = false;             % Измеряем ли напряжение внешним вольтметром?
cf.extI = false;             % Измеряем ли ток внешним амперметром?
cf.manV = false;            % Записываем ли напряжение индикатора на панели (ручной ввод)?
cf.acquireCurrent = true;   % Измеряем ли ток?
%cf.Rext = 9991800;           % Внешнее сопротивление [Ом]
cf.Rext = 1000000000;           % Внешнее сопротивление [Ом]

cf.verboseLevel = 2;        % Уровень занудства сообщений в консоли: 0, 1, 2

cf.vmin = -500;
cf.vmax = 500;
cf.vstep = 20;

cf.ptime = 0.7;             % Время ожидания после установки напряжения смещения
cf.waitTime = 1;          % Время ожидания после коммутации реле (пределы, HV)
cf.samplesCount = 5;    % Размер выборки для усреднения по внешнему вольтметру/амперметру

vrange = cf.vmin:cf.vstep:cf.vmax;

%vrange = [-490:1:-251 -250:10:-50 50:10:250 251:1:490];

%cf.adcId = 51;
cf.adcId = 1;
cf.didoId = 52;
cf.dacId = 50;
cf.ADC_voltage_reg = 3;
cf.ADC_current_reg = 1;

cf.vo_address = '172.16.19.62'; % Адрес внешнего вольтметра
cf.mbport = 'COM2'; % Адрес ВАХ ящика

%cf.mbcount = 0; % Счетчик modbus запросов

cf.m = modbus('serialrtu', cf.mbport);
cf.m.Timeout = 3;

if ~getMbState(cf)
    error('Device must be in MODBUS mode.');
end

if cf.extV || cf.extI
    cf.vo = visadev(sprintf('tcpip0::%s::instr', cf.vo_address));
    cf.vo.Timeout = 30;
end

% Save the Server ID specified.

vv = []; % Напряжение по АЦП
ve = []; % Напряжение по внешнему вольтметру
vi = []; % Напряжение по индикатору на панели
ve = []; % Напряжение по внешнему вольтметру
vt = []; % Развертка по времени внешнего вольтметра
ie = []; % Ток по внешнему амперметру
it = []; % Развертка по времени внешнего амперметра
vi = []; % Напряжение по индикатору на панели
vs = []; % Уставка ЦАП по напряжению
ii = []; % Измеренные токи
rr = []; % Пределы измерения при которых измерялись токи
tt = []; % Время цикла измерения

setHVState(0, cf);
setCurrentRange([0 0 0 0 1 0], cf);
setVoltage(0, cf)
setHVState(1, cf);

for i = vrange
    tic;
    cf.mbcount = 0; % Счетчик modbus запросов
    verbosePrint("-- Voltage step %d/%d: %d [V].\n", 0, cf.verboseLevel, find(vrange == i), numel(vrange), i);
    setVoltage(i, cf);
    vs = [vs; i];

    v0 = getADCVoltage(cf, 5);
    vv = [vv; v0];
    
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
        [ve0, vt0] = readExternalVoltmeter(cf);
        ve = [ve; ve0];
        vt = [vt; vt0];
    end
    
    if cf.extI
        [ie0, it0] = readExternalAmpermeter(cf);
        ie = [ie; ie0];
        it = [it; it0];
    end
    
    elapsed = toc;
    verbosePrint("   Modbus requests: %d.\n", 2, cf.verboseLevel, cf.mbcount);
    verbosePrint("-- Voltage step %d [V] finished: V=%.2f [V]; I=%.2e [A]. Time: %.2f.\n", 1, cf.verboseLevel, i, v0, i0, elapsed);
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
save(sprintf('%s/scandata.mat', path), 'vi', 've', 'vv', 'vs', 'vt', 'ie', 'it', 'cf', 'ii', 'rr');
kbd2file(sprintf('%s/readme.txt', path), 'Enter description: ', true);

disp('All done. Take a beer!');
