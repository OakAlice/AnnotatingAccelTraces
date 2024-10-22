

% --- Executes on button press in load_accel_button.
% Callback function to synchronize accelerometer data with video
function load_accel_button_Callback(hObject, eventdata, handles)

    % Reset delay and zoom settings in the GUI
    set(handles.delay_text, 'String', '0');
    set(handles.zoom_toggle, 'Value', 0);

    %% Calculate video start and end time
    % Get the video end time from the GUI
    videoendtime = get(handles.set_accel_start_datetime, 'String');
    
    % Convert the video end time string to a datetime format
    DateNumber = datetime(videoendtime);
    
    % Calculate the start time of the video by subtracting the duration from the end time
    DateNumber_start = DateNumber - seconds((handles.totalframes * (1 / handles.framerate)));

    %% Load accelerometer data file
    % Open a file selection dialog for accelerometer data
    [handles.accelfilename, handles.pathname] = uigetfile('*.csv*', 'Pick file');
    handles.accelfile = fullfile(handles.pathname, handles.accelfilename);
    
    %% Load the first two rows of the accelerometer data to determine the time interval
    try
        % Read the first two rows of accelerometer data
        accel_temp = dlmread(handles.accelfile, ',', [0, 0, 1, 3]);
    catch
        % If dlmread fails, fall back to using importdata
        accel_temp = importdata(handles.accelfile);
    end

    % Calculate the time interval between the first two accelerometer readings
    time_interval_in_seconds = etime(datevec(accel_temp(2, 1)), datevec(accel_temp(1, 1)));

    %% Find the corresponding accelerometer data for the video start time
    % Calculate the time difference between the start of the accelerometer data and the start of the video
    time_interval_in_seconds2 = etime(datevec(DateNumber_start), datevec(accel_temp(1, 1)));

    % Calculate the starting index for the accelerometer data that aligns with the video start time
    start = round(time_interval_in_seconds2 / time_interval_in_seconds);
    handles.start = start;

    % Calculate the ending index for the accelerometer data based on the video duration
    end_vid = round(start + (handles.totalframes * (1 / handles.framerate)) / ...
                    (1 / str2double(get(handles.set_accel_frame_rate, 'String'))));

    %% Apply buffer to the start and end indices to account for any drift or inaccuracies
    % Add buffer (pre and post) to the calculated start and end indices
    start_buffer = start - str2double(get(handles.set_buffer, 'String'));
    end_buffer = round(end_vid + str2double(get(handles.set_buffer, 'String')));

    % Ensure that the start buffer is not negative (prevents out-of-bounds indexing)
    if start_buffer < 0
        start_buffer = 0;
    end

    % Ensure the end buffer does not exceed the length of the data
    try
        % Read the accelerometer data with the applied buffers
        accel_chunk = dlmread(handles.accelfile, ',', [start_buffer, 0, end_buffer, 3]);
    catch
        % In case of error, fall back to a more conservative end index
        accel_chunk = dlmread(handles.accelfile, ',', [start_buffer, 0, end_vid, 3]);
    end

    % Store the accelerometer data in handles
    handles.accel_chunk = accel_chunk;

    % Update the GUI with the start timestamp of the loaded accelerometer data
    set(handles.accel_name_text, 'String', datestr(accel_chunk(1, 1)));

    %% Initialize a behaviors vector
    % Create a vector of zeros to represent behaviors (length equal to accelerometer data)
    handles.behaviours = zeros(length(accel_chunk(:, 1)), 1);

    % Save the updated handles structure
    guidata(hObject, handles);

    %% Update displays with the loaded accelerometer data
    % Call the functions to update accelerometer display on the GUI
    display_large_accel_fun(hObject, eventdata, handles);
    display_small_accel_fun(hObject, eventdata, handles);
end



% --- Executes on text edit change for accel_name_text.
function accel_name_text_Callback(hObject, eventdata, handles)
    % hObject    handle to accel_name_text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Add your functionality here for handling text input changes.
end

% --- Executes during object creation, after setting all properties for accel_name_text.
function accel_name_text_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to accel_name_text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end

% --- Executes on text edit change for set_buffer.
function set_buffer_Callback(hObject, eventdata, handles)
    % hObject    handle to set_buffer (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Add your functionality here for handling text input changes.
end

% --- Executes during object creation, after setting all properties for set_buffer.
function set_buffer_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to set_buffer (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end




% --- Executes on text edit change for set_accel_start_datetime.
function set_accel_start_datetime_Callback(hObject, eventdata, handles)
    % hObject    handle to set_accel_start_datetime (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Add functionality for processing the accelerometer date input here
end

% --- Executes during object creation, after setting all properties for set_accel_start_datetime.
function set_accel_start_datetime_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to set_accel_start_datetime (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end

% --- Executes on text edit change for set_accel_frame_rate.
function set_accel_frame_rate_Callback(hObject, eventdata, handles)
    % hObject    handle to set_accel_frame_rate (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get the input value and validate it
    handles.accelerationRate = str2double(get(hObject, 'String'));
    
    % Validate the acceleration rate
    if isnan(handles.accelerationRate) || handles.accelerationRate <= 0
        errordlg('Please enter a valid positive number for acceleration rate.', 'Invalid Input');
        return;
    end
    
    % Store the updated handles structure
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties for set_accel_frame_rate.
function set_accel_frame_rate_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to set_accel_frame_rate (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end
