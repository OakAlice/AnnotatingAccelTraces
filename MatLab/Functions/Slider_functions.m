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