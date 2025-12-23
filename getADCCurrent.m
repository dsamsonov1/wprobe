function i0 = getADCCurrent(a_cf, nSamples)

    tic
    verbosePrint('Current ADC requested: %d samples.\n', 2, a_cf.verboseLevel, nSamples);

    samples = zeros(1, nSamples, 'single');

    for i = 1:nSamples
        %для 12-битного ацп
        %i0 = read(a_cf.m, 'inputregs', 1, 1, a_cf.adcId, 'uint16');

        %для 24-битного ацп
        registers = read(a_cf.m, 'holdingregs', a_cf.ADC_current_reg, 2, a_cf.adcId); % адрес, 2 регистра
        reg16 = uint16(registers);
        rawValue = bitor(bitshift(int32(reg16(1)), 16), int32(reg16(2)));

        i00 = single(rawValue)/10000;
        samples(i) = i00;
        verbosePrint('  Current sample (%d/%d): r1=%04X, r2=%04X, converted: %08X (%.2f).\n', 2, a_cf.verboseLevel, i, nSamples, reg16(1), reg16(2), rawValue, i00);
        

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
            i0 = mean(validSamples);
        else
            i0 = mean(samples);
        end
    else
        i0 = samples(1);
    end

    elapsed = toc;
    verbosePrint('  Current raw ADC: %.2f. Time: %.2f [s].\n', 2, a_cf.verboseLevel, i0, elapsed);
end
