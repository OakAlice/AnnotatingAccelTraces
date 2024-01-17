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
from PyQt6.QtCore import Qt, QThread
from matplotlib.figure import Figure

from DisplayAccel import FriendlyFigureCanvas

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

class JackPlotWidget(QWidget):

    start_index_signal = pyqtSignal(int)

    def __init__(self, parent=None, file_path: str = "Maple1_on_GOPR0434.csv"):
        super().__init__(parent)
        self.setWindowTitle("Jack was here")

        self.figure = Figure()
        self.ax = self.figure.add_subplot()
        
        self.canvas = FriendlyFigureCanvas(self.figure)
 
        # Connect up mouse events on the canvas to our class.
        self.canvas.mouseMoveEventSignal.connect(self.canvasMouseMoveEvent)
        self.canvas.mousePressEventSignal.connect(self.canvasMousePressEvent)
        self.canvas.mouseReleaseEventSignal.connect(self.canvasMouseReleaseEvent)

        self.start_idx = 0
        self.start_index_signal.connect(self.update_start_idx)

        # Add dataframe to figure
        df = read_and_process_csv(file_path)
        self.dataframe = df
        self.hardcoded_dataframe_samples = 200 # How many frames we will consider at once. Currently cant scroll.
        self.plot_data(self.start_idx)

        # Create the layout so that we can add things to the Plotwidget
        self.layout = QVBoxLayout()
        # layout.setContentsMargins(0,0,0,0)
        self.layout.addWidget(self.canvas)
        self.setLayout(self.layout)

        
        self.behaviours: List[Behaviour] = [] # DEFAULT_BEHAVIOURS
        self.current_idx = -1 if len(self.behaviours) == 0 else 0

        self.current_bounding_box: List[int, int] = [-1, -1]
        self.behaviour_segments: Dict[Behaviour, List[List[int, int]]] = defaultdict(list)


    def add_behaviour(self, name: str, colour: QColor):
        self.behaviours.append(Behaviour(title=name, colour=colour.name()))

    def set_active_behaviour(self, name: str, colour: QColor) -> bool:
        matching = list(filter(lambda b: b[1].title == name, enumerate(self.behaviours)))
        if len(matching) == 1:
            self.current_idx = matching[0][0]
            return True
        elif len(matching) == 0:
            self.add_behaviour(name, colour)
            return self.set_active_behaviour(name, colour)
        return False

    def update_start_idx(self, idx: int):
        print(f"self.start_idx = {self.start_idx}")
        self.start_idx = idx
        self.draw()

    def plot_data(self, start_index):
        # print(f"self.dataframe is not None: {self.dataframe}, {self.dataframe is not None}")
        if self.dataframe is not None:
            self.ax.clear()
            self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 1], color='red', linewidth=0.5)
            self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 2], color='green', linewidth=0.5)
            self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 3], color='blue', linewidth=0.5)
            # self.figure.subplots_adjust(left=0, right=1, top=1, bottom=0)

            # TODO: ADd back this to fix when dataframe < self.hardcoded_dataframe_samples
            # end_index = min(len(self.dataframe), self.hardcoded_dataframe_samples)
            self.ax.set_xlim(self.dataframe.iloc[self.start_idx, 0], self.dataframe.iloc[self.start_idx + self.hardcoded_dataframe_samples - 1, 0])
        
            self.canvas.draw()

    def _plot_data(self, start_index):
        self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 1], color='red', linewidth=0.5)
        self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 2], color='green', linewidth=0.5)
        self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 3], color='blue', linewidth=0.5)
        self.ax.margins(0)

        # TODO: ADd back this to fix when dataframe < self.hardcoded_dataframe_samples
        # end_index = min(len(self.dataframe), self.hardcoded_dataframe_samples)
        self.ax.set_xlim(self.dataframe.iloc[self.start_idx, 0], self.dataframe.iloc[self.start_idx + self.hardcoded_dataframe_samples - 1, 0])

    def store_and_clear_current_bounding_box(self):
        self.behaviour_segments[self.behaviours[self.current_idx]].append(self.current_bounding_box)
        self.current_bounding_box = [-1, -1]

    def canvasMousePressEvent(self, event: MouseEvent):
        if self.dataframe is not None:
            idx = self.get_dataframe_index_of_mouse(event)
            if self.dataframe_x_in_view(idx):
                self.current_bounding_box[0] = idx

    def canvasMouseMoveEvent(self, event: MouseEvent):
        pass
        # if self.dataframe is not None:
        #     print(f"mouse movee event, {self.get_relative_mouse_position(event)}")

    def draw(self):
        self.ax.clear()
        self._plot_data(self.start_idx)
        
        self.store_and_clear_current_bounding_box()
        self.add_all_patches()
        self.canvas.draw()

    def canvasMouseReleaseEvent(self, event: MouseEvent):
        if self.dataframe is not None:
            idx = self.get_dataframe_index_of_mouse(event)
            if not self.dataframe_x_in_view(idx) or self.current_bounding_box[0] == -1:
                return
            self.current_bounding_box[1] = idx
            self.store_and_clear_current_bounding_box()
            
            self.draw()
            
            print(f"Storage: {self.behaviour_segments}")

    def add_all_patches(self):
        b = self.behaviours[self.current_idx]
        patches = self.behaviour_segments[b]
        for behavior, patches in self.behaviour_segments.items():
            for p in patches:
                x0, x1 = p
                
                # Only add patches that are now visibly in frame.
                if self.dataframe_x_in_view(x0) and self.dataframe_x_in_view(x1):
                    rect: Rectangle = self.segment_to_canvas_rectange(p[0], p[1])
                    rect.set_color(behavior.colour)
                    self.ax.add_patch(rect)

    def get_relative_mouse_position(self, event: MouseEvent) -> Tuple[float, float]:
        """
        This calculates the relative x, y co-ordinates of the mouse event relative to the canvas. 
        Coordinates are normalised between [0, 1.0] with the top left corner being (0, 0).
        """
        return (event.pos().x())/(self.canvas.width()), event.pos().y()/self.canvas.height()

    def get_dataframe_index_of_mouse(self, event: MouseEvent) -> float:
        """Compute where, x-coordinate, in the self.dataframe the mouse is currently at. This works for all mouse events."""
        # TODO: once we support scrolling + zoom, we will need to worry about offsets/conversions etc.
        x, y = self.get_relative_mouse_position(event)
        pos = self.ax.get_position()
        # print("pos: ", pos, (event.pos().x())/(self.canvas.width()), (event.pos().y())/(self.canvas.height()))
        x, y = (x-pos.x0)/(pos.x1-pos.x0), (x-pos.y0)/(pos.y1- pos.y0)

        return self.start_idx + (x * self.hardcoded_dataframe_samples)

    def dataframe_x_in_view(self, idx: int) -> bool:
        """Returns true if the dataframe index, idx is currently visibly on the axis."""
        return idx >= self.start_idx and idx < self.start_idx + self.hardcoded_dataframe_samples

    def segment_to_canvas_rectange(self, a: float, b: float) -> Rectangle:
        x0, x1 = self.convert_segment_to_canvas(a, b)
        return Rectangle([a, 0], b-a, 4)

    def convert_segment_to_canvas(self, a: float, b:float) -> Tuple[float, float]:
        return [(self.canvas.width() * (x -self.start_idx)) /self.hardcoded_dataframe_samples for x in [a, b]] 

import time 

class Worker(QThread):
    start_index_signal = pyqtSignal(int)

    def run(self):
        i = 0
        while True:
            self.start_index_signal.emit(i)
            time.sleep(1)
            i += 20

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = JackPlotWidget()

    # Simulate a signal to continuous update the starting index of PlotWidget
    worker = Worker()
    worker.start_index_signal.connect(lambda x: window.start_index_signal.emit(x))
    worker.start()

    window.show()
    sys.exit(app.exec())