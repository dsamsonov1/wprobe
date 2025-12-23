function kbd2file(filename, prompt_text, append_mode)
    % KEYBOARD_INPUT_TO_FILE Читает ввод с клавиатуры и записывает в файл
    %
    % Синтаксис:
    %   kbd2file(filename)
    %   kbd2file(filename, prompt_text)
    %   kbd2file(filename, prompt_text, append_mode)
    %
    % Входные параметры:
    %   filename - имя файла для записи (обязательный)
    %   prompt_text - текст приглашения для ввода (по умолчанию: 'Введите текст: ')
    %   append_mode - режим записи: 
    %                 true - добавить в конец файла (по умолчанию)
    %                 false - перезаписать файл
    
    % Проверка количества входных аргументов
    if nargin < 1
        error('Необходимо указать имя файла');
    end
    
    % Установка значений по умолчанию
    if nargin < 2
        prompt_text = 'Введите текст (для завершения введите пустую строку): ';
    end
    
    if nargin < 3
        append_mode = true;
    end
    
    % Проверка корректности имени файла
    if ~ischar(filename) && ~isstring(filename)
        error('Имя файла должно быть строкой');
    end
    
    % Преобразование string в char, если необходимо
    filename = char(filename);
    
    % Определяем режим открытия файла
    if append_mode
        file_mode = 'a';  % Добавление
    else
        file_mode = 'w';  % Перезапись
    end
    
    % Открываем файл
    try
        fid = fopen(filename, file_mode, 'n', 'windows-1251');
        if fid == -1
            error('Не удалось открыть файл: %s', filename);
        end
    catch ME
        fprintf('Ошибка при открытии файла: %s\n', ME.message);
        rethrow(ME);
    end
    
    % Выводим информацию о режиме записи
    if append_mode && exist(filename, 'file')
        fprintf('Текст будет добавлен в конец файла: %s\n', filename);
    else
        fprintf('Создание нового файла: %s\n', filename);
    end
    
    % Запрашиваем ввод с клавиатуры
    fprintf('\n%s\n', prompt_text);
    fprintf('(Для завершения ввода введите пустую строку или нажмите Ctrl+C)\n\n');
    
    line_count = 0;
    user_quit = false;
    
    % Основной цикл ввода
    while true
        try
            % Считываем строку
            input_line = input('> ', 's');
            
            % Проверяем на завершение ввода
            if isempty(input_line)
                fprintf('\nВвод завершен.\n');
                break;
            end
            
            % Записываем строку в файл
            fprintf(fid, '%s\n', input_line);
            line_count = line_count + 1;
            
        catch ME
            if strcmp(ME.identifier, 'MATLAB:input:UndefinedFunction')
                % Пользователь нажал Ctrl+C
                fprintf('\n\nВвод прерван пользователем.\n');
                user_quit = true;
                break;
            else
                % Другая ошибка
                fprintf('Ошибка при вводе: %s\n', ME.message);
                user_quit = true;
                break;
            end
        end
    end
    
    % Закрываем файл
    fclose(fid);
end