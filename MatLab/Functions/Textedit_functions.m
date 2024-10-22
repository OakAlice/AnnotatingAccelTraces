
% --- Executes on text edit change for video_name_text.
function video_name_text_Callback(hObject, eventdata, handles)
    % hObject    handle to video_name_text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Add your functionality here for handling text input changes.
end

% --- Executes during object creation, after setting all properties for video_name_text.
function video_name_text_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to video_name_text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
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


% --- Executes on text edit change for vid_frame_rate_text.
function vid_frame_rate_text_Callback(hObject, eventdata, handles)
    % hObject    handle to vid_frame_rate_text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Add your functionality here for handling text input changes.
end

% --- Executes during object creation, after setting all properties for vid_frame_rate_text.
function vid_frame_rate_text_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to vid_frame_rate_text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end

% --- Executes on text edit change for set_frame_step_value.
function set_frame_step_value_Callback(hObject, eventdata, handles)
    % hObject    handle to set_frame_step_value (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Add your functionality here for handling text input changes.
end

% --- Executes during object creation, after setting all properties for set_frame_step_value.
function set_frame_step_value_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to set_frame_step_value (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end

% --- Executes on text edit change for current_frame.
function current_frame_Callback(hObject, eventdata, handles)
    % hObject    handle to current_frame (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Convert the string input to a double and update the frame number
    handles.frame = str2double(get(handles.current_frame, 'String'));
    
    % Optional: Validate the input to ensure it is within acceptable bounds
    if isnan(handles.frame) || handles.frame < 1 || handles.frame > handles.totalframes
        errordlg('Invalid frame number. Please enter a number between 1 and total frames.', 'Invalid Input');
        return;
    end

    guidata(hObject, handles);
    display_video_fun(hObject, eventdata, handles);  % Call display function to update the UI
end



% --- Executes during object creation, after setting all properties for current_frame.
function current_frame_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to current_frame (see GCBO)
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

% --- Executes on text edit change for delay_text.
function delay_text_Callback(hObject, eventdata, handles)
    % hObject    handle to delay_text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get the input value and validate it
    handles.delay = str2double(get(hObject, 'String'));
    
    % Validate the delay value
    if isnan(handles.delay) || handles.delay < 0
        errordlg('Please enter a valid non-negative number for delay.', 'Invalid Input');
        return;
    end
    
    % Store the updated handles structure
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties for delay_text.
function delay_text_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to delay_text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end

% --- Executes on text edit change for set_behaviour_number.
function set_behaviour_number_Callback(hObject, eventdata, handles)
    % hObject    handle to set_behaviour_number (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get the input value and validate it
    handles.behaviorNum = str2double(get(hObject, 'String'));
    
    % Validate the behavior number
    if isnan(handles.behaviorNum) || handles.behaviorNum < 1
        errordlg('Please enter a valid positive integer for behavior number.', 'Invalid Input');
        return;
    end
    
    % Store the updated handles structure
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties for set_behaviour_number.
function set_behaviour_number_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to set_behaviour_number (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end