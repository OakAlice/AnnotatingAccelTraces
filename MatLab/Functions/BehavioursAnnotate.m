
% --- Executes on button press in annotation_trigger_button.
function annotation_trigger_button_Callback(hObject, eventdata, handles)
    % Get behavior number from the edit field
    behnum = str2double(get(handles.set_behaviour_number, 'String'));

    % Initialize variables
    xmin = [];
    xmax = [];
    xmin1 = [];
    xmax1 = [];
    
    % Get two points from user input using ginput
    [x, y] = ginput(2);
    xmin1 = round(x(1));  % Round first x-coordinate
    xmax1 = round(x(2));  % Round second x-coordinate

    % Ensure the coordinates are valid
    xmin1 = max(1, xmin1);  % Minimum value should be at least 1
    if xmin1 > xmax1
        % Swap if the start point is greater than the end point
        xmax1 = xmin1; 
        xmin1 = xmax1;
    end

    % Tag behaviors based on zoom state
    if get(handles.zoom_toggle, 'Value') == 0
        % If not in zoom mode, tag directly on behaviors
        handles.behaviours(xmin1:xmax1) = behnum;
    else
        % If in zoom mode, adjust the indices accordingly
        handles.behaviours(handles.start_zoom + xmin1:handles.start_zoom + xmax1) = behnum;
    end

    % Save updated handles structure
    guidata(hObject, handles);
    
    % Update the display to reflect tagged behaviors
    display_small_accel_fun(hObject, eventdata, handles);
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