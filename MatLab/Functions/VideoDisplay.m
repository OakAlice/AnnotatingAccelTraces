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

            % Display the frame in the axes
            imshow(mov);

            % Pause to simulate video playback at the correct framerate
            pause(1 / handles.framerate);
        end
    end

    % Save the updated handles structure (to preserve changes made in the function)
    guidata(hObject, handles);
end
