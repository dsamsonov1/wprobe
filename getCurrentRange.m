function o_range = getCurrentRange(a_cf)
    o_range = read(a_cf.m, 'inputs', 1, 6, a_cf.didoId);
    verbosePrint('Current range requested.\n', 2, a_cf.verboseLevel);
end
