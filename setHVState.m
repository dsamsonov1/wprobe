function setHVState(a_state, m, didoId, waitTime)

    write(m, 'coils', 23, a_state, didoId);
    pause(waitTime);
    check = getHVState(m, didoId);
    if ~isequal(check, a_state)
        error('HV state setting failed.');
    end
end