# managing the complex layout
from PyQt6.QtWidgets import QWidget, QSlider, QVBoxLayout, QHBoxLayout, QPushButton, QLabel, QSpinBox, QGridLayout
from PyQt6.QtCore import Qt
from DisplayAccel import PlotWidget
from VideoPlayer import VideoPlayer

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

        # plot the csv
        self.plotWidget = PlotWidget()

        # slide the guide line
        self.guidelineSlider = QSlider(Qt.Orientation.Horizontal)
        self.guidelineSlider.setRange(0, 100)  ## TODO: Edit this to be dynamic

        # the video
        self.videoPlayer = VideoPlayer()

        # Behaviour buttons
        #self.behaviourButtons = BehaviourButtons()

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

        # Behaviour buttons layout
        ## here

        # Add the layouts to the main grid layout
        layout.addLayout(videoLayout, 0, 0)
        layout.addLayout(csvLayout, 1, 0)
        layout.addWidget(self.plotWidget, 6, 0, 1, 6)
        layout.addWidget(self.videoPlayer, 0, 2, 2, 3)

    def update_duration_label(self, duration):
        self.durationLabel.setText(f"Duration: {duration}")