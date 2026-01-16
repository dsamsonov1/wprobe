clear cf;

cf.extV = false;             % Измеряем ли напряжение внешним вольтметром?
cf.extI = false;             % Измеряем ли ток внешним амперметром?
cf.manV = false;            % Записываем ли напряжение индикатора на панели (ручной ввод)?
cf.acquireCurrent = true;   % Измеряем ли ток по АЦП?
cf.acquireVoltage = true;   % Измеряем ли напряжение по АЦП?
%cf.Rext = 9991800;           % Внешнее сопротивление [Ом]
cf.Rext = 1000000000;           % Внешнее сопротивление [Ом]
cf.autorange = true;        % Пробовать ли установить предел по току автоматически?
cf.currentSamples = 3;

cf.verboseLevel = 2;        % Уровень занудства сообщений в консоли: 0, 1, 2

%cf.vmin = -500;             % Начало диапазона сканирования напряжения [В]
%cf.vmax = 500;              % Конец диапазона сканирования напряжения [В]
%cf.vmin = -60;             % Начало диапазона сканирования напряжения [В]
%cf.vmax = 100;              % Конец диапазона сканирования напряжения [В]

cf.vstep = 0.1;              % Шаг сканирования [В]

cf.ptime = 0.5;             % Время ожидания после установки напряжения смещения [с]
cf.waitTime = 1;            % Время ожидания после коммутации реле (пределы, HV) [с]
cf.samplesCount = 3;        % Размер выборки для усреднения по внешнему вольтметру/амперметру

%vrange = cf.vmin:cf.vstep:cf.vmax;

vrange = [-150:4:-115 -114:1:-50 -49:3:15 16:1:50 51:4:100];
%vrange = -4:1:5;

%cf.adcId = 51;
cf.adcId = 1;
cf.didoId = 52;
cf.dacId = 50;
cf.ADC_voltage_reg = 3;
cf.ADC_current_reg = 1;

cf.vo_address = '172.16.19.62';     % Адрес внешнего вольтметра
cf.mb_address = '172.16.19.112';    % Адрес ВАХ ящика в случае Modbus TCP

cf.mbport = 'COM10'; % Адрес ВАХ ящика в случае COM порта

%cf.mbcount = 0; % Счетчик modbus запросов

cf.m = modbus('serialrtu', cf.mbport, 'BaudRate', 9600);
%cf.m = modbus('tcpip', cf.mb_address);
cf.m.Timeout = 5;

[~, path] = createOutputFolder('out/', 'scan', 'vv');

cf.verboseLog = true;
cf.verboseLogFile = sprintf('%s/scan.log', path);


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

scantimestamp = datetime;

for i = vrange
    tStart = tic;
%    cf.mbcount = 0; % Счетчик modbus запросов
    verbosePrint("-- Voltage step %d/%d: %d [V].\n", 0, cf, find(vrange == i), numel(vrange), i);

    setVoltage(i, cf);
    vs = [vs; i];

    if cf.acquireVoltage
        v0 = getADCVoltage(cf, 3);
        vv = [vv; v0];
    end
    
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
    
    elapsed = toc(tStart);
    tt = [tt elapsed];
%    verbosePrint("   Modbus requests: %d.\n", 2, cf.verboseLevel, cf.mbcount);
    verbosePrint("-- Voltage step %d [V] finished: V=%.2f [V]; I=%.2e [A]. Time: %.2f [s].\n", 1, cf, i, v0, i0, elapsed);
end

verbosePrint("Total scan time: %.2f [s] (avg %.1f [s/point]).\n", 1, cf, sum(tt), sum(tt)/numel(vrange));

setVoltage(0, cf);
setHVState(0, cf);
setCurrentRange([0 0 0 0 1 0], cf);

if isfield(cf, 'm')
    cf = rmfield(cf, 'm');
end
if isfield(cf, 'vo')
    cf = rmfield(cf, 'vo');
end

save(sprintf('%s/scandata.mat', path), 'vi', 've', 'vv', 'vs', 'vt', 'ie', 'it', 'cf', 'ii', 'rr', 'tt', 'scantimestamp');
kbd2file(sprintf('%s/readme.txt', path), 'Enter description: ', true);

disp('All done. Take a beer!');
