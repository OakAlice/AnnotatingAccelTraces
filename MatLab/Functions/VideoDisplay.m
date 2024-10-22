% function for displaying and playing the video

function display_video_fun(hObject, eventdata, handles)
% display_video_fun: Main function to update the display with the current video frame.
% This function updates the GUIs axes to show the current video frame 
% based on the selected frame number and video file type.
%
% Inputs:
%   - hObject: Handle to the calling object (typically the GUI figure).
%   - eventdata: Reserved for future use (automatically passed by MATLAB).
%   - handles: Structure containing GUI handles and user data.

    % Set the target axes for displaying the video frame
    axes(handles.video_display);

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

