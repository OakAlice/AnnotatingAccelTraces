
%PUSH BUTTON functions

% --- Executes on button press in load_video_button.
% Callback function for the 'Video' button. This function allows the user
% to select a video file and initializes video playback parameters.
function load_video_button_Callback(hObject, eventdata, handles)
    % Open a file selection dialog for video or image files
    [handles.videofilename, handles.pathname] = uigetfile(...
        {'*.MOV;*.avi;*.MP4;*.seq', 'Video files'; '*.tif;*.jpg;*.bmp', 'Image files'}, 'Pick a file');
    
    % Construct the full file path to the selected video
    handles.videofile = fullfile(handles.pathname, handles.videofilename);
    
    % Extract the file name and extension
    [~, handles.name, handles.ext] = fileparts(handles.videofile);

    %% Initialize video properties if the selected file is a video
    % Create a VideoReader object for the video file
    video = VideoReader(handles.videofile);
    
    % Read the last frame to initialize the video (this step could be optional)
    lastFrame = read(video, inf);
    
    % Retrieve the number of frames from the video
    numFrames = video.NumberOfFrames;
    
    % Store video object and properties in handles
    handles.video = video;
    handles.totalframes = video.NumberOfFrames; % Total number of frames
    handles.height = video.Height;             % Video height in pixels
    handles.width = video.Width;               % Video width in pixels
    
    % Calculate the white level for video display (depends on the video's bit depth)
    handles.white = 2^(video.BitsPerPixel / 3) - 1; 
    
    % Get the video's frame rate (frames per second)
    handles.framerate = video.FrameRate;
    
    % Update the GUI to show the frame rate
    set(handles.vid_frame_rate_text, 'String', handles.framerate);
    
    % Initialize the video slider
    set(handles.video_slider, 'max', handles.totalframes, 'min', 1, 'Value', 1);
    set(handles.video_slider, 'SliderStep', [1 / handles.totalframes, 10 / handles.totalframes]);
    
    % Set the current frame number in the GUI to 1
    set(handles.current_frame, 'String', '1');
    
    % Update the GUI to display the video file name
    set(handles.video_name_text, 'String', handles.videofilename);
    
    % Initialize the first frame and other control variables
    handles.frame = 1;
    handles.rect = [];
    handles.stop = 0;

    % Save the updated handles structure
    guidata(hObject, handles);
    
    % Call the display function to show the first frame of the video
    display_video_fun(hObject, eventdata, handles);
end



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







% --- Executes on button press in zoom_trigger_button.
function zoom_trigger_button_Callback(hObject, eventdata, handles)
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

    % Set the zoom radio button to checked
    set(handles.zoom_toggle, 'Value', 1);                
    
    % Set the start and end points for zoom
    handles.start_zoom = xmin1;
    handles.end_zoom = xmax1;

    % Save updated handles structure
    guidata(hObject, handles);
    
    % Update the display for zooming effect
    display_large_accel_fun(hObject, eventdata, handles);
end

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

% --- Executes on button press in zoom_toggle.
function zoom_toggle_Callback(hObject, eventdata, handles)
    % Update the handles structure to reflect any changes
    guidata(hObject, handles);

    % Update display for zoomed view
    display_large_accel_fun(hObject, eventdata, handles);
    
    % Update any additional displays or components affected by zoom
    display_small_accel_fun(hObject, eventdata, handles);
end