import matplotlib.pyplot as plt
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas, NavigationToolbar2QT as NavigationToolbar
from PyQt6.QtWidgets import QPushButton, QScrollBar, QVBoxLayout, QWidget, QHBoxLayout
from PyQt6.QtCore import Qt
import pandas as pd
import pyqtgraph as pg
from PyQt6.QtCore import QUrl, Qt, pyqtSignal
from PyQt6.QtGui import QColor
from matplotlib.patches import Rectangle

def read_and_process_csv(file_path):
    df = pd.read_csv(file_path)
    time = pd.to_datetime(df.iloc[:, 0], unit='s', origin=pd.Timestamp('1970-01-01'))
    df.iloc[:, 0] = time
    return df

class PlotWidget(QWidget):
    def __init__(self, video_change_signal_ms: pyqtSignal, fps_input: pyqtSignal, parent=None):
        super().__init__(parent)

        self.selectedRegions = [] # itialise the coordinates selected

        self.figure, self.ax = plt.subplots(figsize=(5, 1))
        self.canvas = FigureCanvas(self.figure)
        self.currentColor = QColor()  # Default color

        # Initial plot setup to remove axis ticks and minimize margins
        self.ax.tick_params(axis='both', which='both', bottom=False, top=False, 
                            left=False, right=False, labelbottom=False, labelleft=False)
        self.figure.subplots_adjust(left=0, right=1, top=1, bottom=0)

        # Scrollbar through the trace
        self.scrollbar = QScrollBar(Qt.Orientation.Horizontal)
        self.scrollbar.valueChanged.connect(self.update_plot)

        # Zoom Buttons
        self.zoomInButton = QPushButton("+", self)
        self.zoomOutButton = QPushButton("-", self)
        self.zoomInButton.clicked.connect(self.zoom_in)
        self.zoomOutButton.clicked.connect(self.zoom_out)
        self.zoomInButton.setFixedSize(30, 30)
        self.zoomOutButton.setFixedSize(30, 30)

        # Layout
        layout = QVBoxLayout()
        layout.addWidget(self.canvas)

        # Zoom buttons layout
        zoomLayout = QHBoxLayout()
        zoomLayout.addWidget(self.zoomInButton)
        zoomLayout.addWidget(self.zoomOutButton)
        layout.addLayout(zoomLayout)

        # Second scrollbar for controlling the vertical line # functional
        self.vline_scrollbar = QScrollBar(Qt.Orientation.Horizontal)
        self.vline_scrollbar.valueChanged.connect(self.update_vline_position)
        layout.addWidget(self.vline_scrollbar)  # Add it above or below the plot as desired

        layout.addWidget(self.scrollbar)
        self.setLayout(layout)

        self.dataframe = None
        self.zoom_level = 1
        
        # Connect signals to slots within PlotWidget
        self.video_change_single_ms = video_change_signal_ms
        self.video_change_single_ms.connect(self.handle_change_in_video)
        
        self.fps = None

        fps_input.connect(self.handle_change_in_fps)

    # functions
    # part one of converting the fps
    def handle_change_in_fps(self, new_fps: int):
        self.fps = new_fps

    # how much to move the vline by
    def handle_change_in_video(self, relative_change_ms: int):
        if self.fps is not None and self.dataframe is not None:
            frame_change = int((relative_change_ms / 1000.0) * self.fps)
            new_index = min(max(0, self.vline_scrollbar.value() + frame_change), len(self.dataframe) - 1)
            self.vline_scrollbar.setValue(new_index)
        else:
            pass # this was previously the print statement

    # load in the data, plot it
    def load_data(self, dataframe):
        self.dataframe = dataframe
        self.plot_data(0)
        self.scrollbar.setRange(0, len(dataframe) - 1)
        self.vline_scrollbar.setRange(0, len(dataframe) - 1)
        # Initialize the vertical line at the start of the plot
        self.update_vline_position(0)

    # the plot function specifically
    def plot_data(self, start_index):
        if self.dataframe is not None:
            # Plot the entire data
            self.ax.clear()
            self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 1], color='red', linewidth=0.5)
            self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 2], color='green', linewidth=0.5)
            self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 3], color='blue', linewidth=0.5)
            self.figure.subplots_adjust(left=0, right=1, top=1, bottom=0)
            if not hasattr(self, 'vline'):
                self.vline = self.ax.axvline(x=self.dataframe.iloc[0, 0], color='k', linestyle='--')  # Black dashed line
            else:
                self.update_vline_position(self.vline_scrollbar.value()) 
            self.canvas.draw()

    def zoom_in(self):
        self.zoom_level = max(1, self.zoom_level * 0.8)  # Decrease zoom level (zoom in)
        self.update_plot(self.scrollbar.value())

    def zoom_out(self):
        self.zoom_level = min(5, self.zoom_level * 1.2)  # Increase zoom level (zoom out)
        self.update_plot(self.scrollbar.value())

    def update_plot(self, value):
        if self.dataframe is not None:
            window_size = 100  # Define a suitable window size
            start_index = max(0, value - int(window_size * self.zoom_level / 2))
            end_index = min(len(self.dataframe), start_index + int(window_size * self.zoom_level))
            self.ax.set_xlim(self.dataframe.iloc[start_index, 0], self.dataframe.iloc[end_index - 1, 0])
            self.canvas.draw()

    def update_vline(self, position):
        if self.dataframe is not None and position < len(self.dataframe):
            new_x = self.dataframe.iloc[position, 0]
            self.vline.set_xdata([new_x, new_x])
            self.canvas.draw()

    def update_vline_position(self, value):
        if self.dataframe is not None and 0 <= value < len(self.dataframe):
            new_x = self.dataframe.iloc[value, 0]
            self.vline.set_xdata([new_x, new_x])
            self.canvas.draw()

    def mousePressEvent(self, event):
        if self.dataframe is not None:
            # Convert pixel coordinates to data coordinates
            ax = self.canvas.figure.gca()
            xdata, _ = ax.transData.inverted().transform((event.pos().x(), event.pos().y()))
            
            # Initialize the selection rectangle
            self.selectionRect = Rectangle((xdata, self.ax.get_ylim()[0]), 0, self.ax.get_ylim()[1], color=self.currentColor.name(), alpha=0.3)
            self.ax.add_patch(self.selectionRect)
            self.canvas.draw()

    def mouseMoveEvent(self, event):
        if self.dataframe is not None and self.selectionRect is not None:
            # Convert pixel coordinates to data coordinates
            ax = self.canvas.figure.gca()
            xdata, _ = ax.transData.inverted().transform((event.pos().x(), event.pos().y()))
            
            # Update the width of the rectangle
            new_width = xdata - self.selectionRect.get_x()
            self.selectionRect.set_width(new_width)
            self.canvas.draw()

    def mouseReleaseEvent(self, event):
        if self.dataframe is not None and self.selectionRect is not None:
            # Convert pixel coordinates to data coordinates
            ax = self.canvas.figure.gca()
            xdata, _ = ax.transData.inverted().transform((event.pos().x(), event.pos().y()))

            # Calculate the final width of the selection rectangle
            final_width = xdata - self.selectionRect.get_x()
            self.selectionRect.set_width(final_width)

            # Store the selected region
            start = self.selectionRect.get_x()
            end = start + final_width
            self.selectedRegions.append((start, end))

            # Color the region (optional: remove the selection rectangle)
            self.colorRegion(start, end)
            self.selectionRect = None

            # Redraw the canvas
            self.canvas.draw()

    def colorRegion(self, start, end):
        # Add a colored rectangle to cover the selected region
        colored_rect = Rectangle((start, self.ax.get_ylim()[0]), end - start, self.ax.get_ylim()[1], color=self.currentColor.name(), alpha=0.3)
        self.ax.add_patch(colored_rect)

    def setBehaviourColor(self, color: QColor):
        self.currentColor = color

    