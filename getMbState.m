function r = getMbState(m, didoId)
    r = read(m, 'inputs', 11, 1, didoId);
end
