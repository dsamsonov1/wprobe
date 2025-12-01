function v0 = getADCVoltage(m, adcId)
    v0 = read(m, 'inputregs', 2, 1, adcId, 'uint16')-500;
end
