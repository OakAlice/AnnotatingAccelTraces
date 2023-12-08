import matplotlib.pyplot as plt
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas, NavigationToolbar2QT as NavigationToolbar
from PyQt6.QtWidgets import QPushButton, QScrollBar, QVBoxLayout, QWidget, QHBoxLayout
from PyQt6.QtCore import Qt
import pandas as pd
import numpy as np

def read_and_process_csv(file_path):
    df = pd.read_csv(file_path)
    time = pd.to_datetime(df.iloc[:, 0], unit='s', origin=pd.Timestamp('1970-01-01'))
    df.iloc[:, 0] = time
    return df

class PlotWidget(QWidget):
    def __init__(self, parent=None):
        super().__init__(parent)

        self.figure, self.ax = plt.subplots(figsize=(5, 1))
        self.canvas = FigureCanvas(self.figure)

        # Initial plot setup to remove axis ticks and minimize margins
        self.ax.tick_params(axis='both', which='both', bottom=False, top=False, 
                            left=False, right=False, labelbottom=False, labelleft=False)
        self.figure.subplots_adjust(left=0, right=1, top=1, bottom=0)

        # Scrollbar
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

        layout.addWidget(self.scrollbar)
        self.setLayout(layout)

        self.dataframe = None
        self.zoom_level = 1

    # functions
    # load in the data, plot it, and the vertical line
    def load_data(self, dataframe):
        self.dataframe = dataframe
        self.plot_data(0)
        #self.guideline = self.ax.axvline(x=self.dataframe.iloc[0, 0], color='red', linewidth=1)
        # Set scrollbar range
        self.scrollbar.setRange(0, len(dataframe) - 1)

    # the plot function specifically
    def plot_data(self, start_index):
        if self.dataframe is not None:
            # Plot the entire data
            self.ax.clear()
            self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 1], color='red', linewidth=0.5)
            self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 2], color='green', linewidth=0.5)
            self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 3], color='blue', linewidth=0.5)
            # Add the initial vertical line
            if not hasattr(self, 'time_line') or self.time_line is None:
                self.time_line = self.ax.axvline(x=self.dataframe.iloc[0, 0], color='red', linewidth=1)

            self.figure.subplots_adjust(left=0, right=1, top=1, bottom=0)
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