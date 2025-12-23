function setHVState(a_state, a_cf)

    write(a_cf.m, 'coils', 23, a_state, a_cf.didoId);
    pause(a_cf.waitTime);
    check = getHVState(a_cf);
    if ~isequal(check, a_state)
        error('HV state setting failed. Check _/ _ switch is off.');
    end
end