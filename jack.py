from collections import defaultdict
from PyQt6.QtWidgets import QApplication
import sys
from dataclasses import dataclass
from typing import List, Tuple, Dict

from matplotlib.backend_bases import MouseEvent
from matplotlib.figure import Figure
import matplotlib.pyplot as plt
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.patches import Rectangle

import pandas as pd
import pyqtgraph as pg
from PyQt6.QtCore import QUrl, Qt, pyqtSignal
from PyQt6.QtGui import QColor, QMouseEvent
from matplotlib.patches import Rectangle
from PyQt6.QtWidgets import QPushButton, QScrollBar, QVBoxLayout, QWidget, QHBoxLayout
from PyQt6.QtCore import Qt
from DisplayAccel import FriendlyFigureCanvas
from matplotlib.figure import Figure

def read_and_process_csv(file_path):
    df = pd.read_csv(file_path)
    # time = pd.to_datetime(df.iloc[:, 0], unit='s', origin=pd.Timestamp('1970-01-01'))
    df.iloc[:, 0] = df.index
    return df

@dataclass
class Behaviour:
    title: str
    colour: str

    def __hash__(self) -> int:
        """Define how to hash this Behaviour dataclass"""
        return 2*self.title.__hash__() + 3*self.colour.__hash__()

DEFAULT_BEHAVIOURS = [Behaviour("sitting", "blue"), Behaviour("walking", "green")]

class PlotWidget(QWidget):
    def __init__(self, parent=None, file_path: str = "Maple1_on_GOPR0434.csv"):
        super().__init__(parent)
        self.setWindowTitle("Jack was here")

        self.figure = Figure()
        self.ax = self.figure.add_subplot()
        # self.ax.axis([0, 1, 0, 1])
        
        self.canvas = FriendlyFigureCanvas(self.figure)
 
        # Connect up mouse events on the canvas to our class.
        self.canvas.mouseMoveEventSignal.connect(self.canvasMouseMoveEvent)
        self.canvas.mousePressEventSignal.connect(self.canvasMousePressEvent)
        self.canvas.mouseReleaseEventSignal.connect(self.canvasMouseReleaseEvent)

        # Add dataframe to figure
        df = read_and_process_csv(file_path)
        self.dataframe = df
        self.hardcoded_dataframe_samples = 1000 # How many frames we will consider at once. Currently cant scroll.
        self.plot_data(0)

        # Create the layout so that we can add things to the Plotwidget
        layout = QVBoxLayout()
        layout.addWidget(self.canvas)
        self.setLayout(layout)

        
        self.behaviours: List[Behaviour] = DEFAULT_BEHAVIOURS
        self.current_idx = -1 if len(self.behaviours) == 0 else 0

        self.current_bounding_box: List[int, int] = [-1, -1]
        self.behaviour_segments: Dict[Behaviour, List[List[int, int]]] = defaultdict(list)

    def plot_data(self, start_index):
        print(f"self.dataframe is not None: {self.dataframe}, {self.dataframe is not None}")
        if self.dataframe is not None:
            self.ax.clear()
            self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 1], color='red', linewidth=0.5)
            self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 2], color='green', linewidth=0.5)
            self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 3], color='blue', linewidth=0.5)
            self.figure.subplots_adjust(left=0, right=1, top=1, bottom=0)

            end_index = min(len(self.dataframe), self.hardcoded_dataframe_samples)
            self.ax.set_xlim(self.dataframe.iloc[0, 0], self.dataframe.iloc[end_index - 1, 0])

            self.canvas.draw()

    def _plot_data(self, start_index):
        self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 1], color='red', linewidth=0.5)
        self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 2], color='green', linewidth=0.5)
        self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 3], color='blue', linewidth=0.5)
        # self.figure.subplots_adjust(left=0, right=1, top=1, bottom=1)

    def canvasMousePressEvent(self, event: MouseEvent):
        if self.dataframe is not None:
            self.current_bounding_box[0] = self.get_dataframe_index_of_mouse(event)

    def canvasMouseMoveEvent(self, event: MouseEvent):
        pass
        # if self.dataframe is not None:
        #     print(f"mouse movee event, {self.get_relative_mouse_position(event)}")


    def store_and_clear_current_bounding_box(self):
        self.behaviour_segments[self.behaviours[self.current_idx]].append(self.current_bounding_box)
        self.current_bounding_box = [-1, -1]

    def canvasMouseReleaseEvent(self, event: MouseEvent):
        event.pos()
        if self.dataframe is not None:
            self.current_bounding_box[1] = self.get_dataframe_index_of_mouse(event)
            
            # FOr now, we'll just rerender after this
            rect: Rectangle = self.segment_to_canvas_rectange(self.current_bounding_box[0], self.current_bounding_box[1])
            rect.set_color(self.behaviours[self.current_idx].colour)
            
            self.ax.clear()
            self._plot_data(0)
            self.ax.add_patch(rect)
            
            self.canvas.draw()

            self.store_and_clear_current_bounding_box()
            print(f"Storage: {self.behaviour_segments}")



    def get_relative_mouse_position(self, event) -> Tuple[float, float]:
        """
        This calculates the relative x, y co-ordinates of the mouse event relative to the canvas. 
        Coordinates are normalised between [0, 1.0] with the top left corner being (0, 0).
        """
        return event.pos().x()/self.canvas.width(), event.pos().y()/self.canvas.height()

    def get_dataframe_index_of_mouse(self, event: MouseEvent) -> float:
        """Compute where, x-coordinate, in the self.dataframe the mouse is currently at. This works for all mouse events."""
        # TODO: once we support scrolling + zoom, we will need to worry about offsets/conversions etc.
        return self.get_relative_mouse_position(event)[0] * self.hardcoded_dataframe_samples

    def segment_to_canvas_rectange(self, a: float, b: float) -> Rectangle:
        x0, x1 = self.convert_segment_to_canvas(a, b)
        return Rectangle([a, 0], b-a, 4)
        # return Rectangle([x0, 0], x1-x0, 100)

    def convert_segment_to_canvas(self, a: float, b:float) -> Tuple[float, float]:
        return [(self.canvas.width() * x)/self.hardcoded_dataframe_samples for x in [a, b]] 

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = PlotWidget()
    window.show()
    sys.exit(app.exec())