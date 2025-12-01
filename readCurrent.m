function [current, r0] = readCurrent(m, didoId, adcId, rm, waitTime)

    cr = getCurrentRange(m, didoId);
    cri = find(cr);
    ovl = checkOvl(m, didoId);
    success = true;
    while ovl && success
        [success, cr] = selectRange(1, cri, cr);
        cri = find(cr);
        if success
            setCurrentRange(cr, m, didoId, waitTime);
            ovl = checkOvl(m, didoId);
        end
    end

    if ~success && ovl
        current = NaN;
        r0 = cri;
        return;
    end

    cc = getADCCurrent(m, adcId);

    if cc <= 100
        success = true;
        while cc <= 100 && success
            [success, cr] = selectRange(0, cri, cr);
            cri = find(cr);
            if success
                setCurrentRange(cr, m, didoId, waitTime);
            end
            cc = getADCCurrent(m, adcId);
        end
    end
    csign = getCurrentSign(m, didoId);
    current = bsign(csign)*cc/1000*rm(cri);
    r0 = cri;
end