% vline function

function h = vline(x)
    % vline - Draw vertical lines at specified x-coordinates with a default red dashed line.
    %
    % Usage:
    %   h = vline(x)   % Draw vertical lines at the x-coordinates specified in x

    % Check if input is a vector
    if length(x) > 1
        % Loop through each element of x
        for I = 1:length(x)
            h(I) = drawVLine(x(I)); % Draw the vertical line for each x value
        end
    else
        h = drawVLine(x);  % Handle single value of x
    end

    if nargout
        hhh = h;  % Return handle if requested
    end
end

% Helper function to draw a vertical line
function h = drawVLine(x)
    y = get(gca, 'ylim');  % Get current y-limits
    h = plot([x x], y, 'r:');  % Plot vertical line with default red dashed line

    % Optional label placement (if needed in the future)
    % Uncomment the following code if you want to add labels later
    % xx = get(gca, 'xlim');  % Get current x-limits
    % xrange = xx(2) - xx(1);  % Calculate x-range
    % text(x + 0.01 * xrange, y(1) + 0.1 * (y(2) - y(1)), 'Label', 'color', get(h, 'color'));
    
    set(h, 'tag', 'vline', 'handlevisibility', 'off');  % Set properties
end
