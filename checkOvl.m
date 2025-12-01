function ovl = checkOvl(m, didoId)
    ovl = any(read(m, 'inputs', 7, 2, didoId));
end