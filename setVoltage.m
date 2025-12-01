function setVoltage(a_v, m, dacId, waitTime)
    write(m, 'holdingregs', 2049, a_v+500, dacId, 'uint16');
    pause(waitTime);
end
