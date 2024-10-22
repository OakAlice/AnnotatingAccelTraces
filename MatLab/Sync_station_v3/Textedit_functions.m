
% --- Executes on text edit change for edit1.
function edit1_Callback(hObject, eventdata, handles)
    % hObject    handle to edit1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Add your functionality here for handling text input changes.
end

% --- Executes during object creation, after setting all properties for edit1.
function edit1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end

% --- Executes on text edit change for edit2.
function edit2_Callback(hObject, eventdata, handles)
    % hObject    handle to edit2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Add your functionality here for handling text input changes.
end

% --- Executes during object creation, after setting all properties for edit2.
function edit2_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end

% --- Executes on text edit change for edit3_buffer.
function edit3_buffer_Callback(hObject, eventdata, handles)
    % hObject    handle to edit3_buffer (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Add your functionality here for handling text input changes.
end

% --- Executes during object creation, after setting all properties for edit3_buffer.
function edit3_buffer_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit3_buffer (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end


% --- Executes on text edit change for edit4_getframe.
function edit4_getframe_Callback(hObject, eventdata, handles)
    % hObject    handle to edit4_getframe (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Add your functionality here for handling text input changes.
end

% --- Executes during object creation, after setting all properties for edit4_getframe.
function edit4_getframe_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit4_getframe (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end

% --- Executes on text edit change for edit5_frame_step.
function edit5_frame_step_Callback(hObject, eventdata, handles)
    % hObject    handle to edit5_frame_step (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Add your functionality here for handling text input changes.
end

% --- Executes during object creation, after setting all properties for edit5_frame_step.
function edit5_frame_step_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit5_frame_step (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end

% --- Executes on text edit change for edit_framenum.
function edit_framenum_Callback(hObject, eventdata, handles)
    % hObject    handle to edit_framenum (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Convert the string input to a double and update the frame number
    handles.frame = str2double(get(handles.edit_framenum, 'String'));
    
    % Optional: Validate the input to ensure it is within acceptable bounds
    if isnan(handles.frame) || handles.frame < 1 || handles.frame > handles.totalframes
        errordlg('Invalid frame number. Please enter a number between 1 and total frames.', 'Invalid Input');
        return;
    end

    guidata(hObject, handles);
    mydisplay(hObject, eventdata, handles);  % Call display function to update the UI
end



% --- Executes during object creation, after setting all properties for edit_framenum.
function edit_framenum_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit_framenum (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end

% --- Executes on text edit change for edit_acceldate.
function edit_acceldate_Callback(hObject, eventdata, handles)
    % hObject    handle to edit_acceldate (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Add functionality for processing the accelerometer date input here
end

% --- Executes during object creation, after setting all properties for edit_acceldate.
function edit_acceldate_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit_acceldate (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end

% --- Executes on text edit change for edit_accelrate.
function edit_accelrate_Callback(hObject, eventdata, handles)
    % hObject    handle to edit_accelrate (see GCBO)
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

% --- Executes during object creation, after setting all properties for edit_accelrate.
function edit_accelrate_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit_accelrate (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end

% --- Executes on text edit change for edit_delay.
function edit_delay_Callback(hObject, eventdata, handles)
    % hObject    handle to edit_delay (see GCBO)
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

% --- Executes during object creation, after setting all properties for edit_delay.
function edit_delay_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit_delay (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end

% --- Executes on text edit change for edit_behnum.
function edit_behnum_Callback(hObject, eventdata, handles)
    % hObject    handle to edit_behnum (see GCBO)
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

% --- Executes during object creation, after setting all properties for edit_behnum.
function edit_behnum_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit_behnum (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end