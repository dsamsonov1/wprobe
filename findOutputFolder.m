function [found_path, folder_date] = findOutputFolder(base_path, task_name, mode, folder_number)
    % FIND_RESULTS_FOLDER Находит каталог по заданным параметрам
    % Входные параметры:
    %   base_path - базовый путь (XX)
    %   task_name - имя задачи (AA)
    %   mode - режим работы (BB)
    %   folder_number - номер каталога (CCCC) как число или строка
    %
    % Выходные параметры:
    %   found_path - полный путь к найденному каталогу
    %   folder_date - дата создания каталога
    
    % Проверка входных параметров
    if nargin < 4
        error('Недостаточно входных параметров');
    end
    
    % Преобразуем номер в строку из 4 цифр
    if isnumeric(folder_number)
        folder_number_str = sprintf('%04d', folder_number);
    elseif ischar(folder_number) || isstring(folder_number)
        folder_number_str = sprintf('%04d', str2double(folder_number));
    else
        error('Номер каталога должен быть числом или строкой');
    end
    
    % Проверка корректности номера
    if str2double(folder_number_str) > 9999 || str2double(folder_number_str) < 1
        error('Номер каталога должен быть от 0001 до 9999');
    end
    
    % Валидация имени задачи (убираем недопустимые символы)
    task_name_clean = regexprep(task_name, '[<>:"/\\|?*]', '_');
    
    % Паттерн для поиска
    pattern = sprintf('%s_%s_%s_\\d{4}-\\d{2}-\\d{2}', ...
        task_name_clean, mode, folder_number_str);
    
    % Ищем каталоги
    all_items = dir(base_path);
    found_path = '';
    folder_date = '';
    
    for i = 1:length(all_items)
        if all_items(i).isdir && ~strcmp(all_items(i).name, '.') && ~strcmp(all_items(i).name, '..')
            folder_name = all_items(i).name;
            
            % Проверяем соответствие паттерну
            if ~isempty(regexp(folder_name, pattern, 'once'))
                found_path = fullfile(base_path, folder_name);
                
                % Извлекаем дату из имени каталога
                tokens = regexp(folder_name, '.*_.*_.*_(\d{4}-\d{2}-\d{2})', 'tokens');
                if ~isempty(tokens)
                    folder_date = tokens{1}{1};
                end
                break;
            end
        end
    end
    
    % Если каталог не найден
    if isempty(found_path)
        warning('Каталог не найден для параметров: %s, %s, %s', ...
            task_name, mode, folder_number_str);
    end
end