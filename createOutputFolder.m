function [folder_number, full_path] = createOutputFolder(base_path, task_name, mode)
    % CREATE_RESULTS_FOLDER Создает каталог для хранения результатов
    % Входные параметры:
    %   base_path - базовый путь (XX)
    %   task_name - имя задачи (AA)
    %   mode - режим работы (BB)
    %
    % Выходные параметры:
    %   folder_number - номер каталога в виде строки CCCC
    %   full_path - полный путь к созданному каталогу
    
    % Проверка входных параметров
    if nargin < 3
        error('Недостаточно входных параметров');
    end
    
    % Валидация режима работы (ровно 2 символа)
    if ~ischar(mode) || length(mode) ~= 2
        error('Режим работы должен быть строкой из 2 символов');
    end
    
    % Валидация имени задачи (убираем недопустимые символы)
    task_name_clean = regexprep(task_name, '[<>:"/\\|?*]', '_');
    if length(task_name_clean) > 50
        task_name_clean = task_name_clean(1:50);
        warning('Имя задачи сокращено до 50 символов');
    end
    
    % Получаем текущую дату
    current_date = datestr(now, 'yyyy-mm-dd');
    
    % Ищем существующие каталоги с совпадающими task_name и mode
    pattern = sprintf('%s_%s_(\\d{4})_', task_name_clean, mode);
    existing_folders = dir(fullfile(base_path, [task_name_clean '_' mode '_*_*']));
    
    % Определяем максимальный номер
    max_number = 0;
    for i = 1:length(existing_folders)
        if existing_folders(i).isdir
            folder_name = existing_folders(i).name;
            tokens = regexp(folder_name, pattern, 'tokens');
            if ~isempty(tokens)
                num_str = tokens{1}{1};
                num_val = str2double(num_str);
                if num_val > max_number
                    max_number = num_val;
                end
            end
        end
    end
    
    % Определяем следующий номер
    next_number = max_number + 1;
    
    % Проверка на превышение максимального номера
    if next_number > 9999
        error('Достигнут максимальный номер каталога (9999)');
    end
    
    % Форматируем номер как строку из 4 цифр
    folder_number = sprintf('%04d', next_number);
    
    % Формируем имя каталога
    folder_name = sprintf('%s_%s_%s_%s', ...
        task_name_clean, mode, folder_number, current_date);
    
    % Полный путь
    full_path = fullfile(base_path, folder_name);
    
    % Создаем каталог
    try
        if ~exist(full_path, 'dir')
            mkdir(full_path);
            fprintf('Создан каталог: %s\n', full_path);
        else
            error('Каталог уже существует: %s', full_path);
        end
    catch ME
        fprintf('Ошибка при создании каталога: %s\n', ME.message);
        rethrow(ME);
    end
end