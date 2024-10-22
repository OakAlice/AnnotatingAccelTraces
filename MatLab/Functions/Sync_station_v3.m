function varargout = Sync_station_v3(varargin)
%% initialisation code for Sync_station_v3 project

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @initialise_gui_fun, ...
                   'gui_OutputFcn',  @print_to_terminal_fun, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before Sync_station_v3 is made visible.
function initialise_gui_fun(hObject, eventdata, handles, varargin)
% initialise_gui_fun: Initializes the GUI when it is first opened.
%
% Inputs:
%   - hObject: Handle to the GUI figure (main window).
%   - eventdata: Reserved for future use (automatically passed by MATLAB).
%   - handles: Structure with handles and user data.
%   - varargin: Command line arguments passed to the GUI (optional).

    % Set the default output to the GUI figure handle
    handles.output = hObject;

    % Update the handles structure to make it accessible to other functions
    guidata(hObject, handles);

    % If you want the GUI to pause and wait for user input, uncomment the line below:
    % uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = print_to_terminal_fun(hObject, eventdata, handles)
% print_to_terminal_fun: Returns the output when the GUI is executed.
%
% Inputs:
%   - hObject: Handle to the GUI figure.
%   - eventdata: Reserved for future use (automatically passed by MATLAB).
%   - handles: Structure with handles and user data.
%
% Outputs:
%   - varargout: Cell array for returning the output arguments.

    % Return the figure handle (stored in handles.output) as the output
    varargout{1} = handles.output;
end

