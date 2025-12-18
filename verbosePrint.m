function verbosePrint(a_message, a_thresholdLevel, a_systemVerboseLevel, varargin)

    if a_systemVerboseLevel >= a_thresholdLevel
        try
            if ~isempty(varargin)
                fprintf(a_message, varargin{:});
            else
                fprintf('%s', a_message);
            end
            fprintf('\n');
        catch ME
            error('verbosePrint:formatError', '');
        end
    end
end
