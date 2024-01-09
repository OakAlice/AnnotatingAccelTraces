from PyQt6.QtWidgets import QApplication
import sys
    
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


def read_and_process_csv(file_path):
    df = pd.read_csv(file_path)
    time = pd.to_datetime(df.iloc[:, 0], unit='s', origin=pd.Timestamp('1970-01-01'))
    df.iloc[:, 0] = time
    return df


class FriendlyFigureCanvas(FigureCanvas):

    # Directly pass up mouse events as signals.
    mousePressEventSignal = pyqtSignal(QMouseEvent)
    mouseMoveEventSignal = pyqtSignal(QMouseEvent)
    mouseReleaseEventSignal = pyqtSignal(QMouseEvent)

    def __init__(self, figure: Figure):
        super().__init__(figure=figure)
    
    def mousePressEvent(self, event):
        super().mousePressEvent(event)
        self.mousePressEventSignal.emit(event)

    def mouseMoveEvent(self, event):
        super().mouseMoveEvent(event)
        self.mouseMoveEventSignal.emit(event)

    def mouseReleaseEvent(self, event):
        super().mouseReleaseEvent(event)
        self.mouseReleaseEventSignal.emit(event)


class PlotWidget(QWidget):
    def __init__(self, parent=None, file_path: str = "Maple1_on_GOPR0434.csv"):
        super().__init__(parent)
        self.setWindowTitle("Jack was here")


        self.figure, self.ax = plt.subplots()
        self.canvas = FriendlyFigureCanvas(self.figure)
        df = read_and_process_csv(file_path)
        self.dataframe = df
        self.plot_data(0)

        # Create the layout so that we can add things to the Plotwidget
        layout = QVBoxLayout()
        layout.addWidget(self.canvas)
        self.setLayout(layout)

    def plot_data(self, start_index):
        print(f"self.dataframe is not None: {self.dataframe}, {self.dataframe is not None}")
        if self.dataframe is not None:
            self.ax.clear()
            self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 1], color='red', linewidth=0.5)
            self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 2], color='green', linewidth=0.5)
            self.ax.plot(self.dataframe.iloc[:, 0], self.dataframe.iloc[:, 3], color='blue', linewidth=0.5)
            self.figure.subplots_adjust(left=0, right=1, top=1, bottom=0)

            end_index = min(len(self.dataframe), 1000)
            self.ax.set_xlim(self.dataframe.iloc[0, 0], self.dataframe.iloc[end_index - 1, 0])

            self.canvas.draw()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = PlotWidget()
    window.show()
    sys.exit(app.exec())