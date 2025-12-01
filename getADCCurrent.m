function v0 = getADCCurrent(m, adcId)
    v0 = read(m, 'inputregs', 1, 1, adcId, 'uint16');
end
