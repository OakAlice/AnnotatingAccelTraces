function varargout = Sync_station_v2(varargin)
% SYNC_STATION_V2 MATLAB code for Sync_station_v2.fig
%      This code is an updated version of the accelerometer annotation
%      software designed for Galea et al., 2021 by Chris Clemente. The 
%      function of this program is to annotate a raw accelerometer trace
%      with the behaviours it contains based on concurrently filmed video.
%      A video is loaded, the datetime of the connected

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct(...
    'gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @initialise_gui_fun, ...
    'gui_OutputFcn',  @print_to_terminal_fun, ...
    'gui_LayoutFcn',  [], ...
    'gui_Callback',   []);

if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before Sync_station_v2 is made visible.
function initialise_gui_fun(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to Sync_station_v2 (see VARARGIN)

    % Choose default command line output for Sync_station_v2
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes Sync_station_v2 wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = print_to_terminal_fun(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;

% --- Function for displaying the video
function display_video_fun(hObject, eventdata, handles)
    % main update screen function
    
    axes(handles.video_display);
    
    %% open and show video frame
    if ~isempty(handles.videofile) 
        if strcmp(handles.ext,'.avi') || strcmp(handles.ext,'.AVI')|| strcmp(handles.ext,'.MP4') || strcmp(handles.ext,'.MPG') || strcmp(handles.ext,'.MOV')
            mov = read(handles.video, handles.frame);
        end
        
        imshow(mov);
        pause(1/handles.framerate);
    end
    
    guidata(hObject,handles)

% function for displaying the accelerometer
function display_large_accel_fun(hObject, eventdata, handles)
    axes(handles.large_accelerometer_display)
    
    framerate = str2double(get(handles.vid_frame_rate_text, 'String'));
    samplingF = str2double(get(handles.set_accel_frame_rate, 'String')); 
    handles.Cfact = samplingF/framerate;
    
    delay = str2double(get(handles.delay_text,'String'));
    time_sec = round(handles.frame*handles.Cfact-delay+handles.start);
    
    if get(handles.zoom_toggle,'Value')==0
        % displaying and coloring each of the axes
        plot(handles.accel_chunk(:,2),'b')
        hold on
        plot(handles.accel_chunk(:,3),'r')
        plot(handles.accel_chunk(:,4),'g')
        hold off
        
        vline(time_sec)
    else
        plot(handles.accel_chunk(handles.start_zoom:handles.end_zoom,2),'b')
        hold on
        plot(handles.accel_chunk(handles.start_zoom:handles.end_zoom,3),'r')
        plot(handles.accel_chunk(handles.start_zoom:handles.end_zoom,4),'g')
        hold off  
        
        vline(time_sec-handles.start_zoom)
    end

    guidata(hObject,handles)

% function for displaying the accelerometer 
function display_small_accel_fun(hObject, eventdata, handles)
    axes(handles.small_accelerometer_display)

    framerate = str2double(get(handles.vid_frame_rate_text, 'String'));
    samplingF = str2double(get(handles.set_accel_frame_rate, 'String'));
    handles.Cfact = samplingF/framerate;

    delay = str2double(get(handles.delay_text,'String'));
    time_sec = round(handles.frame*handles.Cfact-delay+handles.start);

    % displaying and coloring each of the axes
    plot(handles.accel_chunk(:,2),'b')
    hold on
    plot(handles.behaviours,'r')
    hold off
    vline(time_sec)

    guidata(hObject,handles)

%PUSH BUTTONS 

% --- Executes on button press in load_video_button.
% Push button for accessing and initializing the video file
function load_video_button_Callback(hObject, eventdata, handles)
    % Get video file from user
    [handles.videofilename, handles.pathname] = uigetfile(...
        {'*.MOV;*.avi;*.MP4;*.seq', 'Video files'; ...
         '*.tif;*.jpg;*.bmp', 'Image files'}, ...
        'Pick file');
    handles.videofile = fullfile(handles.pathname, handles.videofilename);
    [~, handles.name, handles.ext] = fileparts(handles.videofile);

    % Initialize video reader and get properties
    video = VideoReader(handles.videofile);
    lastFrame = read(video, inf);
    numFrames = video.NumberOfFrames;
    
    % Store video properties in handles
    handles.video = video;
    handles.totalframes = video.NumberOfFrames;
    handles.height = video.Height;
    handles.width = video.Width;
    handles.white = 2^(video.BitsPerPixel/3)-1;
    handles.framerate = video.FrameRate;
    
    % Update UI elements
    set(handles.vid_frame_rate_text, 'String', handles.framerate);
    set(handles.video_slider, 'max', handles.totalframes, 'min', 1, 'Value', 1);
    set(handles.video_slider, 'SliderStep', [1/handles.totalframes, 10/handles.totalframes]);
    set(handles.current_frame, 'String', '1');
    set(handles.video_name_text, 'String', handles.videofilename);
    
    % Initialize other handles properties
    handles.frame = 1;
    handles.rect = [];
    handles.stop = 0;

    % Update handles and display video
    guidata(hObject, handles);
    display_video_fun(hObject, eventdata, handles)

function load_accel_button_Callback(hObject, eventdata, handles)
    % Reset display settings
    set(handles.delay_text, 'String', '0')
    set(handles.zoom_toggle, 'Value', 0)

    % Get video end time and calculate start time
    videoendtime = get(handles.set_accel_start_datetime, 'String');
    DateNumber = datetime(videoendtime);
    video_duration = seconds(handles.totalframes * (1/handles.framerate));
    DateNumber_start = DateNumber - video_duration;

    % Load accelerometer file
    [handles.accelfilename, handles.pathname] = uigetfile('*.csv*', 'Select accelerometer file');
    handles.accelfile = fullfile(handles.pathname, handles.accelfilename);

    % Read first two rows of accelerometer data to determine sampling rate
    try
        accel_temp = dlmread(handles.accelfile, ',', [0,0,1,3]);
    catch
        accel_temp = importdata(handles.accelfile);
    end

    % Calculate time intervals
    time_interval_in_seconds = etime(datevec(accel_temp(2,1)), datevec(accel_temp(1,1)));
    time_to_video_start = etime(datevec(DateNumber_start), datevec(accel_temp(1,1)));

    % Calculate start and end indices for accelerometer data
    start = round(time_to_video_start / time_interval_in_seconds);
    handles.start = start;

    % Calculate end index based on video duration
    accel_rate = str2double(get(handles.set_accel_frame_rate, 'String'));
    video_samples = handles.totalframes * (accel_rate/handles.framerate);
    end_vid = round(start + video_samples);

    % Add buffer zones
    buffer_size = str2double(get(handles.set_buffer, 'String'));
    start_buffer = max(0, start - buffer_size);  % Ensure non-negative
    end_buffer = round(end_vid + buffer_size);

    % Load accelerometer chunk with error handling
    try
        accel_chunk = dlmread(handles.accelfile, ',', [start_buffer,0,end_buffer,3]);
    catch
        % If end_buffer is too large, try without buffer
        accel_chunk = dlmread(handles.accelfile, ',', [start_buffer,0,end_vid,3]);
    end

    % Store data in handles
    handles.accel_chunk = accel_chunk;
    set(handles.accel_name_text, 'String', datestr(accel_chunk(1,1)))

    % Initialize behaviors vector
    handles.behaviours = zeros(length(accel_chunk(:,1)), 1);

    % Update displays
    guidata(hObject, handles)
    display_large_accel_fun(hObject, eventdata, handles)
    display_small_accel_fun(hObject, eventdata, handles)

% --- Executes on button press in play_button.
function play_button_Callback(hObject, eventdata, handles)
    global stop
    stop = true;
    
    handles.stop = 0;
    
    % Get step size and current frame
    step = str2double(get(handles.set_frame_step_value, 'String'));
    handles.frame = str2double(get(handles.current_frame, 'String'));
    
    while(1)
        % Check for stop condition
        if stop == false
            break;
        end
        
        % Update frame counter and UI
        handles.frame = handles.frame + step;
        set(handles.video_slider, 'Value', handles.frame);
        set(handles.current_frame, 'String', num2str(handles.frame));
        
        % Check if reached end of video
        if handles.frame > handles.totalframes
            break;
        end
        
        % Update displays
        display_video_fun(hObject, eventdata, handles)
        display_large_accel_fun(hObject, eventdata, handles)
        display_small_accel_fun(hObject, eventdata, handles)
    end
    
% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
    global stop
    stop = false;

% --- Executes on button press in delay_calculation_button.
function delay_calculation_button_Callback(hObject, eventdata, handles)
    % hObject    handle to delay_calculation_button (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get click position
    [x,~] = ginput(1);
    xmin = round(x(1));
    
    % Calculate conversion factor between video and accelerometer sampling rates
    framerate = str2double(get(handles.vid_frame_rate_text, 'String'));
    samplingF = str2double(get(handles.set_accel_frame_rate, 'String')); 
    handles.Cfact = samplingF/framerate;
    
    % Calculate current time in accelerometer samples
    time_sec = round(handles.frame * handles.Cfact + handles.start);
    
    % Calculate delay based on zoom state
    if get(handles.zoom_toggle, 'Value') == 0
        % Not zoomed - delay is difference between current time and click position
        delay = time_sec - xmin;
    else
        % Zoomed - need to account for zoom offset
        delay = time_sec - (handles.start_zoom + xmin);
    end
    
    % Update delay display
    set(handles.delay_text, 'String', num2str(delay));
    
    % Update handles and display
    guidata(hObject, handles);
    display_large_accel_fun(hObject, eventdata, handles)

% --- Executes on button press in zoom_trigger_button.
function zoom_trigger_button_Callback(hObject, eventdata, handles)
xmin=[];
xmax=[];
xmin1=[];
xmax1=[];
[x,y]=ginput(2);
xmin=round(x(1));
xmin1=xmin(1);
xmax=round(x(2));
xmax1=xmax(1);
                if xmin1<0
                    xmin1=1;
                end
                if xmin1>xmax1
                    xmax1=xmin1;
                    xmin1=xmax1;
                else
                    xmin1=xmin1;
                    xmax1=xmax1;
                end

set(handles.zoom_toggle,'Value',1)                
                
%set the start and end points to zoom into. This will be read by the
%display_large_accel_fun function when the zoom radio button is checked. 
handles.start_zoom=xmin1;
handles.end_zoom=xmax1;
guidata(hObject, handles);
display_large_accel_fun(hObject, eventdata, handles)

% --- Executes on button press in load_behaviours_button.
function load_behaviours_button_Callback(hObject, eventdata, handles)
%loads behaviours
[handles.behaviourfilename, handles.pathname]=uigetfile('*.csv*','pick file');
handles.behfile = fullfile(handles.pathname,handles.behaviourfilename);

delimiterIn = ',';
handles.beh=readtable(handles.behfile);

% age = [32 ;23; 15; 17; 21]; 
% names = {'Howard';'Harry'; 'Mark'; 'Nik'; 'Mike'}; 
% gen = {'M'  ;'M' ; 'M'; 'F'; 'M'}; 
%tab = table(handles.beh);

set(handles.behaviours_table, 'Data', table2cell(handles.beh));
set(handles.behaviours_table, 'ColumnName', {'number','behaviour'});
guidata(hObject,handles)

% --- Executes on button press in annotation_trigger_button.
function annotation_trigger_button_Callback(hObject, eventdata, handles)
    behnum = str2num(get(handles.set_behaviour_number, 'String'));
    
    xmin = [];
    xmax = [];
    xmin1 = [];
    xmax1 = [];
    [x,y] = ginput(2);
    xmin = round(x(1));
    xmin1 = xmin(1);
    xmax = round(x(2));
    xmax1 = xmax(1);
    
    if xmin1 < 0
        xmin1 = 1;
    end
    if xmin1 > xmax1
        xmax1 = xmin1;
        xmin1 = xmax1;
    else
        xmin1 = xmin1;
        xmax1 = xmax1;
    end

    if get(handles.zoom_toggle, 'Value') == 0         
        handles.behaviours(xmin1:xmax1) = behnum;
    else
        handles.behaviours(handles.start_zoom+xmin1:handles.start_zoom+xmax1) = behnum;
    end

    guidata(hObject, handles)
    display_small_accel_fun(hObject, eventdata, handles)
% --- Executes on button press in save_accel_button.
function save_accel_button_Callback(hObject, eventdata, handles)
    % Get filename
    filename = get(handles.video_name_text, 'String');
    newStr = extractBefore(filename, '.');
    outfile = [handles.pathname, newStr, '_tagged.csv'];

    % Extract data columns
    time = handles.accel_chunk(:,1);
    x = handles.accel_chunk(:,2);
    y = handles.accel_chunk(:,3); 
    z = handles.accel_chunk(:,4); 
    behnum = handles.behaviours;

    % Initialize activity cell array
    act = NaN(length(handles.accel_chunk(:,2)), 1);
    activity = num2cell(act);

    % Fill in activity labels
    for kk = 1:length(handles.accel_chunk(:,2))
        if handles.behaviours(kk) ~= 0
            activity{kk} = table2array(handles.beh((find(table2array(handles.beh(:,1)) == handles.behaviours(kk))), 2));  
        end
    end

    % Create and write output table
    tableout = table(time, x, y, z, activity, behnum);
    writetable(tableout, outfile)

    fprintf('finished writing accel file\n')

%radio buttons

% --- Executes on button press in zoom_toggle.
function zoom_toggle_Callback(hObject, eventdata, handles)
guidata(hObject,handles)
display_large_accel_fun(hObject, eventdata, handles)
display_small_accel_fun(hObject, eventdata, handles)

% hObject    handle to zoom_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
      
 



%Sliders

% --- Executes on slider movement.
function video_slider_Callback(hObject, eventdata, handles)
% hObject    handle to video_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.frame=round(get(handles.video_slider,'Value'));

if handles.frame>handles.totalframes
    handles.frame=handles.totalframes;
elseif handles.frame<1
    handles.frame=1;
end

set(handles.video_slider,'Value',handles.frame);
set(handles.current_frame,'String',num2str(handles.frame));

guidata(hObject,handles);
display_video_fun(hObject, eventdata, handles);
display_large_accel_fun(hObject, eventdata, handles);
display_small_accel_fun(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function video_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to video_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





%EDIT BUTTONS 

function video_name_text_Callback(hObject, eventdata, handles)
% Empty callback

function video_name_text_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function accel_name_text_Callback(hObject, eventdata, handles)
% Empty callback

function accel_name_text_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function set_buffer_Callback(hObject, eventdata, handles)
% Empty callback

function set_buffer_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function vid_frame_rate_text_Callback(hObject, eventdata, handles)
% Empty callback

function vid_frame_rate_text_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function set_frame_step_value_Callback(hObject, eventdata, handles)
% Empty callback

function set_frame_step_value_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function current_frame_Callback(hObject, eventdata, handles)
    handles.frame=str2double(get(handles.current_frame, 'String'));
    guidata(hObject, handles);
    display_video_fun(hObject, eventdata, handles)

function current_frame_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
    end

function set_accel_start_datetime_Callback(hObject, eventdata, handles)
% Empty callback

function set_accel_start_datetime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function set_accel_frame_rate_Callback(hObject, eventdata, handles)
% Empty callback

function set_accel_frame_rate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function delay_text_Callback(hObject, eventdata, handles)
% Empty callback

function delay_text_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function set_behaviour_number_Callback(hObject, eventdata, handles)
% Empty callback

function set_behaviour_number_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in vline_button.
if length(x)>1  % vector input
    for I=1:length(x)
        switch nargin
        case 1
            linetype='r:';
            label='';
        case 2
            if ~iscell(in1)
                in1={in1};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            label='';
        case 3
            if ~iscell(in1)
                in1={in1};
            end
            if ~iscell(in2)
                in2={in2};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            if I>length(in2)
                label=in2{end};
            else
                label=in2{I};
            end
        end
        h(I)=vline(x(I),linetype,label);
    end
else
    switch nargin
    case 1
        linetype='r:';
        label='';
    case 2
        linetype=in1;
        label='';
    case 3
        linetype=in1;
        label=in2;
    end

    
    
    
    g=ishold(gca);
    hold on

    y=get(gca,'ylim');
    h=plot([x x],y,linetype);
    if length(label)
        xx=get(gca,'xlim');
        xrange=xx(2)-xx(1);
        xunit=(x-xx(1))/xrange;
        if xunit<0.8
            text(x+0.01*xrange,y(1)+0.1*(y(2)-y(1)),label,'color',get(h,'color'))
        else
            text(x-.05*xrange,y(1)+0.1*(y(2)-y(1)),label,'color',get(h,'color'))
        end
    end     

    if g==0
    hold off
    end
    set(h,'tag','vline','handlevisibility','off')
end % else

if nargout
    hhh=h;
end
