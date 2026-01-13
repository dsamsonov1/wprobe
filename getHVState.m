function r = getHVState(a_cf)
    r = read(a_cf.m, 'inputs', 10, 1, a_cf.didoId);
    pause(0.001);    
    verbosePrint('HV switch state requested: %d.\n', 2, a_cf, r);
end
