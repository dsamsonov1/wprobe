function r = getHVState(m, didoId)
    r = read(m, 'inputs', 10, 1, didoId);
end
