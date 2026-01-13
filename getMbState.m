function r = getMbState(a_cf)
    r = read(a_cf.m, 'inputs', 11, 1, a_cf.didoId);
    pause(0.001);    
    verbosePrint('MODBUS switch state requested: %d.\n', 2, a_cf, r);
end
