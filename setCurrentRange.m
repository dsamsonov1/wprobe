function setCurrentRange(a_cr, m, didoId, waitTime)

    if sum(a_cr) ~= 1
        error('a_cr must have exactly one bit set to 1');
    end

    if length(a_cr) ~= 6
        error('bit_array must contain exactly 6 bits');
    end

    write(m, 'coils', 17, a_cr, didoId);
    pause(waitTime);
    cr_check = getCurrentRange(m, didoId);
    if ~isequal(a_cr, cr_check)
        error('Range setting failed.');
    end
end