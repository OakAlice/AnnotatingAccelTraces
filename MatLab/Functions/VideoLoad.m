% functions for loading the video

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
    
    % Calculate the white level for video display (depends on the videos bit depth)
    handles.white = 2^(video.BitsPerPixel / 3) - 1; 
    
    % Get the videos frame rate (frames per second)
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


% --- Executes on text edit change for video_name_text.
function video_name_text_Callback(hObject, eventdata, handles)
    % hObject    handle to video_name_text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Add your functionality here for handling text input changes.
end

% --- Executes during object creation, after setting all properties for video_name_text.
function video_name_text_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to video_name_text (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    % See ISPC and COMPUTER.
    if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        % Set a white background for the edit control on Windows
        set(hObject, 'BackgroundColor', 'white');
    end
end