% slider functions
 
% --- Executes on slider movement.
function video_slider_Callback(hObject, eventdata, handles)
    % Get the current value of the slider and round it to the nearest integer
    handles.frame = round(get(handles.video_slider, 'Value'));

    % Ensure the frame number is within valid bounds
    if handles.frame > handles.totalframes
        handles.frame = handles.totalframes; % Cap to total frames
    elseif handles.frame < 1
        handles.frame = 1; % Set to minimum frame
    end

    % Update the slider position and display the current frame number
    set(handles.video_slider, 'Value', handles.frame);
    set(handles.current_frame, 'String', num2str(handles.frame));

    % Update the handles structure to save changes
    guidata(hObject, handles);

    % Refresh the display with the new frame information
    mydisplay(hObject, eventdata, handles);
    mydisplay2(hObject, eventdata, handles);
    mydisplay3(hObject, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function video_slider_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to video_slider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Check if the sliders background color is the same as the default color
    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a light gray background for the slider
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end
end


% --- Executes on button press in play_button.
function play_button_Callback(hObject, eventdata, handles)
    global stop
    stop = true;  % Initialize the stop flag

    handles.stop = 0;  % Reset the stop flag in handles

    % Get the frame step and current frame number from the GUI
    step = str2double(get(handles.set_frame_step_value, 'String'));
    handles.frame = str2double(get(handles.current_frame, 'String'));

    % Start an infinite loop for frame advancement
    while true
        % Stop playing if the stop flag is set
        if stop == false
            break;
        end

        % Advance to the next frame
        handles.frame = handles.frame + step;
        set(handles.video_slider, 'Value', handles.frame);
        set(handles.current_frame, 'String', num2str(handles.frame));

        % Break if the frame exceeds the total number of frames
        if handles.frame > handles.totalframes
            break;
        end

        % Update the display with the new frame
        display_video_fun(hObject, eventdata, handles);
        display_large_accel_fun(hObject, eventdata, handles);
        display_small_accel_fun(hObject, eventdata, handles);
    end  
end  

% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
    global stop
    stop = false;  % Set the stop flag to false
    % Optionally, you can add feedback to the user that stopping was pressed
    % disp('You pressed stop');
end

% --- Executes on button press in delay_calculation_button.
function delay_calculation_button_Callback(hObject, eventdata, handles)
    % Get the cursor position from the user
    [x, y] = ginput(1);
    
    % Round the cursor x-coordinate and ensure its at least 1
    xmin1 = max(1, round(x(1)));

    % Get frame rate and sampling frequency from the GUI
    framerate = str2double(get(handles.vid_frame_rate_text, 'String'));
    samplingF = str2double(get(handles.set_accel_frame_rate, 'String'));
    handles.Cfact = samplingF / framerate;  % Calculate conversion factor

    % Check if in zoom mode
    if get(handles.zoom_toggle, 'Value') == 0
        % Calculate the delay based on current frame and cursor position
        time_sec = round(handles.frame * handles.Cfact + handles.start);
        set(handles.delay_text, 'String', num2str(time_sec - xmin1));
    else
        % If in zoom mode, calculate the new delay considering zoom offsets
        time_sec = round(handles.frame * handles.Cfact + handles.start);
        new_delay = round(time_sec - (handles.start_zoom + xmin1));
        set(handles.delay_text, 'String', num2str(new_delay));
    end

    % Save updated handles structure
    guidata(hObject, handles);

    % Update display with the new delay information
    display_large_accel_fun(hObject, eventdata, handles);
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