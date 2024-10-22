
% --- Executes on button press in save_accel_button.
function save_accel_button_Callback(hObject, eventdata, handles)

    % Get filename from the edit box
    filename = get(handles.video_name_text, 'String');
    newStr = extractBefore(filename, '.');  % Extract the base name without extension
    outfile = fullfile(handles.pathname, [newStr, '_tagged.csv']);  % Create full output file path

    % Extract accelerometer data
    time = handles.accel_chunk(:, 1);
    x = handles.accel_chunk(:, 2);
    y = handles.accel_chunk(:, 3); 
    z = handles.accel_chunk(:, 4); 
    behnum = handles.behaviours;

    % Initialize activity as NaN
    activity = cell(length(handles.accel_chunk(:, 2)), 1);
    activity(:) = {NaN};  % Fill the cell array with NaN

    % Map behaviors to activities
    for kk = 1:length(handles.accel_chunk(:, 2))
        if behnum(kk) ~= 0
            % Find the corresponding activity for the behavior number
            activity{kk} = table2array(handles.beh(find(table2array(handles.beh(:, 1)) == behnum(kk), 1, 'first'), 2));  
        end
    end

    % Create output table with accelerometer data and activities
    tableout = table(time, x, y, z, activity, behnum);

    % Write the table to a CSV file
    writetable(tableout, outfile);

    % Confirm completion of the writing process
    fprintf('Finished writing accelerometer file: %s\n', outfile);
end
