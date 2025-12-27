function [ve0, vt0] = readExternalAmpermeter(a_cf)
        tic;
        verbosePrint("    Reading external ampermeter: %d samples...", 2, a_cf, a_cf.samplesCount);
        vt0 = strrep(a_cf.vo.writeread(sprintf('CONF:CURR:DC AUTO;:SAMP:COUN %d;:CALC:AVER:STAT ON;:INIT;:FETC?', a_cf.samplesCount)), newline, '');
        ve0 = strrep(a_cf.vo.writeread('CALC:AVER:ALL?;:CALC:AVER:COUNT?'), newline, '');
        ve0 = str2double(split(ve0, {',', ';'}))';
        vt0 = str2double(split(vt0, {',', ';'}))';
        elapsed = toc;
        verbosePrint(" Finished: %.2f [s].\n", 2, a_cf, elapsed);
end

