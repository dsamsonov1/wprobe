function o_sign = getCurrentSign(a_cf)
    o_sign = read(a_cf.m, 'inputs', 9, 1, a_cf.didoId);
    verbosePrint('Current sign requested: %d.\n', 2, a_cf, o_sign);
end
