%% functions for displaying the accelerometer in the gui

function mydisplay(hObject, eventdata, handles)
% mydisplay: Main function to update the display with the current video frame.
% This function updates the GUIs axes to show the current video frame 
% based on the selected frame number and video file type.
%
% Inputs:
%   - hObject: Handle to the calling object (typically the GUI figure).
%   - eventdata: Reserved for future use (automatically passed by MATLAB).
%   - handles: Structure containing GUI handles and user data.

    % Set the target axes for displaying the video frame
    axes(handles.axes1);

    %% Check if video file is loaded
    if ~isempty(handles.videofile)
        
        % Check if the video file extension is supported
        if any(strcmpi(handles.ext, {'.avi', '.mp4', '.mpg', '.mov'}))
            % Read the frame at the current position
            mov = read(handles.video, handles.frame);
            
            % Optional: Apply transformations like rotation and adjustments (currently commented out)
            % mov = imrotate(mov, angle);              % Rotate frame (angle is specified by user)
            % mov = imadjust(mov, [low_in; high_in], [0; 1], gamma); % Adjust contrast, brightness, gamma

            % Display the frame in the axes
            imshow(mov);

            % Pause to simulate video playback at the correct framerate
            pause(1 / handles.framerate);
        end
    end

    % Save the updated handles structure (to preserve changes made in the function)
    guidata(hObject, handles);
end

% Function for displaying the smaller accelerometer screen
function mydisplay2(hObject, eventdata, handles)
% mydisplay2: Displays accelerometer data in the GUI, with options for zoom and axis coloring.
%
% Inputs:
%   - hObject: Handle to the calling object (typically the GUI figure).
%   - eventdata: Reserved for future use (automatically passed by MATLAB).
%   - handles: Structure containing GUI handles and user data.

    % Set the target axes for plotting accelerometer data
    axes(handles.axes2);

    % Retrieve the frame rate and sampling frequency from the GUI
    framerate = str2double(get(handles.edit4_getframe, 'String'));  % Frame rate of the video
    samplingF = str2double(get(handles.edit_accelrate, 'String'));  % Accelerometer sampling frequency

    % Calculate the scaling factor between sampling frequency and frame rate
    handles.Cfact = samplingF / framerate;

    % Calculate the time in seconds based on the current frame, compensating for any delay
    delay = str2double(get(handles.edit_delay, 'String'));
    time_sec = round(handles.frame * handles.Cfact - delay + handles.start);

    % Check if zoom mode is off
    if get(handles.radiobutton1_zoom, 'Value') == 0
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
    % axes(handles.axes3);
    % plot(handles.time, handles.act, 'b');

    % Save the updated handles structure
    guidata(hObject, handles);
end


% Function for displaying accelerometer data along with behaviors on axes3
function mydisplay3(hObject, eventdata, handles)
% mydisplay3: Displays accelerometer data and behavioral annotations in the GUI.
%
% Inputs:
%   - hObject: Handle to the calling object (typically the GUI figure).
%   - eventdata: Reserved for future use (automatically passed by MATLAB).
%   - handles: Structure containing GUI handles and user data.

    % Set the target axes for plotting
    axes(handles.axes3);

    % Retrieve frame rate and sampling frequency from the GUI
    framerate = str2double(get(handles.edit4_getframe, 'String'));  % Frame rate of the video
    samplingF = str2double(get(handles.edit_accelrate, 'String'));  % Accelerometer sampling frequency

    % Calculate scaling factor between sampling frequency and frame rate
    handles.Cfact = samplingF / framerate;

    % Calculate the current time in seconds based on the frame number and delay
    delay = str2double(get(handles.edit_delay, 'String'));  % Delay in video/accelerometer alignment
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
    % axes(handles.axes3);
    % plot(handles.time, handles.act, 'b');

    % Update the handles structure with the new data
    guidata(hObject, handles);
end

