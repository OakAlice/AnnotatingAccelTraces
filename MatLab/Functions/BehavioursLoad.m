
% --- Executes on button press in load_behaviours_button.
function load_behaviours_button_Callback(hObject, eventdata, handles)
    % Load behaviors from a CSV file
    [handles.behaviourfilename, handles.pathname] = uigetfile('*.csv*', 'Pick file');
    if isequal(handles.behaviourfilename, 0)
        % User canceled the file selection
        return;
    end
    
    % Construct the full file path and read the table
    handles.behfile = fullfile(handles.pathname, handles.behaviourfilename);
    handles.beh = readtable(handles.behfile);
    
    % Display the behaviors in the uitable
    set(handles.behaviours_table, 'Data', table2cell(handles.beh));
    set(handles.behaviours_table, 'ColumnName', {'Number', 'Behaviour'});
    
    % Save updated handles structure
    guidata(hObject, handles);
end