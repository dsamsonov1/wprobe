function [current, r0] = readCurrent(a_cf)

    rm = [10e-9 100e-9 1e-6 10e-6 100e-6 1e-3]; % Множители для пределов измерения

    cr = getCurrentRange(a_cf);
    ovl = checkOvl(a_cf);
    success = true;

    if a_cf.autorange
        while ovl && success
            [success, cr] = selectRange(1, cr);
            if success
                setCurrentRange(cr, a_cf);
            end
            ovl = checkOvl(a_cf);
        end
    end

    if (~success || a_cf.autorange) && ovl
        current = NaN;
        r0 = find(cr);
        return;
    end

    cc = getADCCurrent(a_cf, a_cf.currentSamples);

    if a_cf.autorange
        success = true;
        while cc <= 0.9995 && success
            [success, cr] = selectRange(0, cr);
            if success
                setCurrentRange(cr, a_cf);
            end
            cc = getADCCurrent(a_cf, a_cf.currentSamples);
        end
    end

    csign = getCurrentSign(a_cf);
    r0 = find(cr);
    current = bsign(csign)*cc/10*rm(r0);
end