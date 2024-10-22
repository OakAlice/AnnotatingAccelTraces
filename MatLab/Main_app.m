function mainApp()
    % Initalising the full script (functions dont actually work this way yet, just drafting)

    % Create the main figure for the GUI
    hFigure = createMainFigure();
    
    % Initialize GUI components in functional units
    % none of these are functional yet - just place holder
    initialise_video_load(hFigure);
    initialise_video_display(hFigure);
    initialise_accel_load(hFigure);
    initialise_accel_display(hFigure);
    initialise_alignment(hFigure);
    initialise_zoom(hFigure);
    initialise_behaviour_load(hFigure);
    initialise_behaviour_tag(hFigure);
    initialise_annotations_save(hFigure);
    
    % Display the GUI
    set(hFigure, 'Visible', 'on'); % Make visible
end

function hFigure = createMainFigure()
    % Create the main figure for the GUI
    hFigure = figure('Name', 'My MATLAB App', 'NumberTitle', 'off', ...
                     'MenuBar', 'none', 'Resize', 'off', ...
                     'Position', [100, 100, 800, 600]);
end
