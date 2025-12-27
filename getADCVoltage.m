function v0 = getADCVoltage(a_cf, nSamples)
    
    samples = zeros(1, nSamples, 'single');

    for i = 1:nSamples
        %для 12-битного ацп
        %v0 = read(a_cf.m, 'inputregs', 2, 1, a_cf.adcId, 'uint16')-500;

        %для 24-битного ацп
        registers = read(a_cf.m, 'holdingregs', a_cf.ADC_voltage_reg, 2, a_cf.adcId); % адрес, 2 регистра
        reg16 = uint16(registers);
        rawValue = bitor(bitshift(int32(reg16(1)), 16), int32(reg16(2)));

        v00 = single(rawValue)*10/1000-500; % тут где-то косяк с переполнением

        verbosePrint('  Voltage sample (%d/%d): r1=0x%04X, r2=0x%04X, converted: 0x%08X (%.2f).\n', 2, a_cf, i, nSamples, reg16(1), reg16(2), rawValue, v00);
        
        samples(i) = v00;

        % Небольшая задержка между измерениями (если нужно)
        if i < nSamples && nSamples > 1
            pause(0.001); % 1 мс задержка
        end
    end

    % Вычисляем среднее значение
    if nSamples > 1
        % Удаляем выбросы
        if nSamples >= 5
            % Отбрасываем 10% минимальных и 10% максимальных значений
            sortedSamples = sort(samples);
            trimCount = floor(nSamples * 0.1);
            validSamples = sortedSamples((trimCount + 1):(end - trimCount));
            v0 = mean(validSamples);
        else
            v0 = mean(samples);
        end
    else
        v0 = samples(1);
    end

    elapsed = toc;
    verbosePrint('  Avg voltage: %.2f. Time: %.2f [s].\n', 1, a_cf, v0, elapsed);
end
