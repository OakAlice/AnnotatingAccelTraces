%% functions for displaying the accelerometer in the gui

% Function for displaying the smaller accelerometer screen
function display_large_accel_fun(hObject, eventdata, handles)
% display_large_accel_fun: Displays accelerometer data in the GUI, with options for zoom and axis coloring.
%
% Inputs:
%   - hObject: Handle to the calling object (typically the GUI figure).
%   - eventdata: Reserved for future use (automatically passed by MATLAB).
%   - handles: Structure containing GUI handles and user data.

    % Set the target axes for plotting accelerometer data
    axes(handles.large_accelerometer_display);

    % Retrieve the frame rate and sampling frequency from the GUI
    framerate = str2double(get(handles.vid_frame_rate_text, 'String'));  % Frame rate of the video
    samplingF = str2double(get(handles.set_accel_frame_rate, 'String'));  % Accelerometer sampling frequency

    % Calculate the scaling factor between sampling frequency and frame rate
    handles.Cfact = samplingF / framerate;

    % Calculate the time in seconds based on the current frame, compensating for any delay
    delay = str2double(get(handles.delay_text, 'String'));
    time_sec = round(handles.frame * handles.Cfact - delay + handles.start);

    % Check if zoom mode is off
    if get(handles.zoom_toggle, 'Value') == 0
        % Plot the full accelerometer data (X, Y, Z axes in blue, red, green)
        plot(handles.accel_chunk(:, 2), 'b');  % X-axis data (blue)
        hold on;
        plot(handles.accel_chunk(:, 3), 'r');  % Y-axis data (red)
        plot(handles.accel_chunk(:, 4), 'g');  % Z-axis data (green)
        hold off;

        % Draw a vertical line at the current time in the plot
        vline(time_sec);

    % If zoom mode is enabled
    else
        % Plot only the zoomed-in section of accelerometer data
        plot(handles.accel_chunk(handles.start_zoom:handles.end_zoom, 2), 'b');  % X-axis data (blue)
        hold on;
        plot(handles.accel_chunk(handles.start_zoom:handles.end_zoom, 3), 'r');  % Y-axis data (red)
        plot(handles.accel_chunk(handles.start_zoom:handles.end_zoom, 4), 'g');  % Z-axis data (green)
        hold off;

        % Draw a vertical line adjusted for zoom at the current time
        vline(time_sec - handles.start_zoom);
    end

    % Optionally, another axes can be set for additional plotting (currently commented out)
    % axes(handles.small_accelerometer_display);
    % plot(handles.time, handles.act, 'b');

    % Save the updated handles structure
    guidata(hObject, handles);
end


% Function for displaying accelerometer data along with behaviors on small_accelerometer_display
function display_small_accel_fun(hObject, eventdata, handles)
% display_small_accel_fun: Displays accelerometer data and behavioral annotations in the GUI.
%
% Inputs:
%   - hObject: Handle to the calling object (typically the GUI figure).
%   - eventdata: Reserved for future use (automatically passed by MATLAB).
%   - handles: Structure containing GUI handles and user data.

    % Set the target axes for plotting
    axes(handles.small_accelerometer_display);

    % Retrieve frame rate and sampling frequency from the GUI
    framerate = str2double(get(handles.vid_frame_rate_text, 'String'));  % Frame rate of the video
    samplingF = str2double(get(handles.set_accel_frame_rate, 'String'));  % Accelerometer sampling frequency

    % Calculate scaling factor between sampling frequency and frame rate
    handles.Cfact = samplingF / framerate;

    % Calculate the current time in seconds based on the frame number and delay
    delay = str2double(get(handles.delay_text, 'String'));  % Delay in video/accelerometer alignment
    time_sec = round(handles.frame * handles.Cfact - delay + handles.start);

    %% Plot accelerometer data and behavior annotations
    % Plot the accelerometer data (X-axis in blue)
    plot(handles.accel_chunk(:, 2), 'b');  % Assuming accel_chunk(:, 2) corresponds to the X-axis data
    hold on;

    % Plot the behavior annotations (assumed in red)
    plot(handles.behaviours, 'r');  % Plot behaviors in red (assumed to be time-aligned data)
    
    % Release hold to prevent further additions to the same plot
    hold off;

    % Draw a vertical line at the current time point to mark the frame position
    vline(time_sec);

    % Optionally, other plots can be added (currently commented out)
    % axes(handles.small_accelerometer_display);
    % plot(handles.time, handles.act, 'b');

    % Update the handles structure with the new data
    guidata(hObject, handles);
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

