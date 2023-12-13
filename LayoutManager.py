# managing the complex layout
from PyQt6.QtWidgets import QWidget, QSlider, QVBoxLayout, QHBoxLayout, QPushButton, QLabel, QSpinBox, QGridLayout
from PyQt6.QtCore import Qt
from DisplayAccel import PlotWidget
from VideoPlayer import VideoPlayer
from BehaviourButtons import NewButton

#from BehaviourButtons import BehaviourButtons

class LayoutManager(QWidget):
    def __init__(self):
        super().__init__()

        # Initialise all of the widgets
        # related to loading in the video
        self.loadVidButton = QPushButton("Browse Video")
        self.videoLabel = QLabel("No video selected")
        self.videoFrameRate = QSpinBox()
        self.videoFrameRate.setRange(1, 240)  # within this range
        self.durationLabel = QLabel("Duration: ") # intialise the label as blank

        # related to loading in the csv
        self.loadCsvButton = QPushButton("Browse CSV")
        self.csvLabel = QLabel("No CSV selected")
        self.csvFrameRate = QSpinBox()
        self.csvFrameRate.setRange(1, 240) 

        # slide the guide line
        self.guidelineSlider = QSlider(Qt.Orientation.Horizontal)
        self.guidelineSlider.setRange(0, 100)  ## TODO: Edit this to be dynamic

        # the video
        self.videoPlayer = VideoPlayer()

        # plot the csv
        self.plotWidget = PlotWidget(self.videoPlayer.videoPositionChanged, self.csvFrameRate.valueChanged)

        # Behaviour buttons
        self.behaviourButtons = NewButton()

        self.setupLayout()

    def setupLayout(self):
        # Create the layout and add the widgets in clusters
        layout = QGridLayout(self)

        # Video file  widgets layout
        videoLayout = QVBoxLayout()

        videoTopLayout = QHBoxLayout()
        videoTopLayout.addWidget(self.loadVidButton)
        videoTopLayout.addWidget(self.videoLabel)
        videoLayout.addLayout(videoTopLayout)
        
        videoBottomLayout = QHBoxLayout()
        videoBottomLayout.addWidget(QLabel("Video Frame Rate:"))
        videoBottomLayout.addWidget(self.videoFrameRate)
        videoLayout.addLayout(videoBottomLayout)

        videoLayout.addWidget(self.durationLabel) # update the duration

        # CSV widgets layout
        csvLayout = QVBoxLayout()
        csvTopLayout = QHBoxLayout()
        csvTopLayout.addWidget(self.loadCsvButton)
        csvTopLayout.addWidget(self.csvLabel)
        csvLayout.addLayout(csvTopLayout)

        csvBottomLayout = QHBoxLayout()
        csvBottomLayout.addWidget(QLabel("CSV Frame Rate:"))
        csvBottomLayout.addWidget(self.csvFrameRate)
        csvLayout.addLayout(csvBottomLayout)

        # Add the layouts to the main grid layout
        layout.addLayout(videoLayout, 0, 0) # loading in the video
        layout.addLayout(csvLayout, 1, 0) # loading in the csv
        layout.addWidget(self.plotWidget, 6, 0, 1, 6) # plotting the csv
        layout.addWidget(self.videoPlayer, 0, 2, 2, 3) # video player and buttons
        layout.addWidget(self.behaviourButtons, 7, 0, 1, 1) # behaviour buttons

    def update_duration_label(self, duration):
        self.durationLabel.setText(f"Duration: {duration}")
