function ovl = checkOvl(a_cf)
%    ovl = any(read(a_cf.m, 'inputs', 7, 2, a_cf.didoId));
    ovl = getADCCurrent(a_cf, 3) > 9.999;
    a_cf.mbcount = a_cf.mbcount + 1;
end