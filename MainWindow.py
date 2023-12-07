from PyQt6.QtWidgets import QFileDialog, QLabel, QMainWindow, QPushButton, QGridLayout, QWidget
from pathlib import Path

from OpenFiles import FileSelection, OpenFileSignals
from VideoPlayer import VideoPlayer


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("AnnotatingAccelTraces V2")

        # Central widget
        centralWidget = QWidget(self)
        self.setCentralWidget(centralWidget)

        # Layout
        layout = QGridLayout(centralWidget)

        # create all elements
        # file opening buttons
        self.loadVidButton = QPushButton("Browse Video", self)
        self.videoLabel = QLabel("No video selected", self)
        self.loadCsvButton = QPushButton("Browse Accel", self)
        self.csvLabel = QLabel("No CSV selected", self)

        # display and play the video
        self.fileSelectionSignals = OpenFileSignals()
        self.openFiles = FileSelection(self.fileSelectionSignals)
        self.videoPlayer = VideoPlayer()
        self.fileSelectionSignals.videoSelected.connect(self.videoPlayer.set_video)


        # design widget layout
        layout.addWidget(self.loadVidButton, 0, 0)
        layout.addWidget(self.videoLabel, 1, 0)
        layout.addWidget(self.loadCsvButton, 2, 0)
        layout.addWidget(self.csvLabel, 3, 0)
        layout.addWidget(self.videoPlayer, 1, 3, 3, 3)

        # actions to take when things happen
        # when loading files
        self.loadVidButton.clicked.connect(lambda: self.openFiles.open_file_dialog(self, self.videoLabel, self.csvLabel, self.loadVidButton))
        self.loadCsvButton.clicked.connect(lambda: self.openFiles.open_file_dialog(self, self.videoLabel, self.csvLabel, self.loadCsvButton))
        