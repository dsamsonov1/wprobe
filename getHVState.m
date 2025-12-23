function r = getHVState(a_cf)
    r = read(a_cf.m, 'inputs', 10, 1, a_cf.didoId);
    verbosePrint('HV switch state requested: %d.\n', 2, a_cf.verboseLevel, r);
end
