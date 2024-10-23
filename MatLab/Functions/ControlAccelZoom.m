
% --- Executes on button press in zoom_toggle.
function zoom_toggle_Callback(hObject, eventdata, handles)
    % Update the handles structure to reflect any changes
    guidata(hObject, handles);

    % Update display for zoomed view
    display_large_accel_fun(hObject, eventdata, handles);
    
    % Update any additional displays or components affected by zoom
    display_small_accel_fun(hObject, eventdata, handles);
end