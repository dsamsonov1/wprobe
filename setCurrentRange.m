function setCurrentRange(a_cr, a_cf)

    if sum(a_cr) ~= 1
        error('a_cr must have exactly one bit set to 1');
    end

    if length(a_cr) ~= 6
        error('bit_array must contain exactly 6 bits');
    end

    verbosePrint('Current range set requested.\n', 2, a_cf);
    write(a_cf.m, 'coils', 17, a_cr, a_cf.didoId);

    pause(a_cf.waitTime);
    verbosePrint('Current range set pause %.2f [s].\n', 2, a_cf, a_cf.waitTime);
    
    cr_check = getCurrentRange(a_cf);
    if ~isequal(a_cr, cr_check)
        error('Range setting failed.');
    end
end