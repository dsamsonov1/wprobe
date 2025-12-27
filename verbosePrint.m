function verbosePrint(a_message, a_thresholdLevel, a_cf, varargin)

    if a_cf.verboseLevel >= a_thresholdLevel
        if ~isempty(varargin)
            formatted_message = sprintf(a_message, varargin{:});
            fprintf(formatted_message, varargin{:});
        else
            formatted_message = sprintf(a_message);
            fprintf(formatted_message);
        end

        % Запись в файл журнала, если включено
        if a_cf.verboseLog
            try
                % Открываем файл для добавления (режим 'a' - append)
                fid = fopen(a_cf.verboseLogFile, 'a');
                if fid == -1
                    warning('verbosePrint:fileError', ...
                        'Не удалось открыть файл журнала: %s', a_cf.verboseLogFile);
                else
                    % Добавляем временную метку
                    timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');
                    fprintf(fid, '[%s] %s', timestamp, formatted_message);
                    fclose(fid);
                end
            catch ME
                warning('verbosePrint:logError', ...
                    'Ошибка при записи в журнал: %s', ME.message);
            end
        end        

    end
end
