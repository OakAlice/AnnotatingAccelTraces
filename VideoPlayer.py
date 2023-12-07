# code for the video player
# adapted from https://doc.qt.io/qtforpython-6/examples/example_multimedia_player.html

from PyQt6.QtWidgets import QWidget, QVBoxLayout, QPushButton, QSlider, QHBoxLayout
from PyQt6.QtMultimedia import QMediaPlayer
from PyQt6.QtMultimediaWidgets import QVideoWidget
from PyQt6.QtCore import QUrl, Qt

class VideoPlayer(QWidget):
    def __init__(self):
        super().__init__()

        # Create a media player object
        self.player = QMediaPlayer()

        # Create a video display widget
        self.videoWidget = QVideoWidget()
        self.player.setVideoOutput(self.videoWidget)

        # Create player controls
        self.playButton = QPushButton("Play")
        self.playButton.clicked.connect(self.play_video)

        self.pauseButton = QPushButton("Pause")
        self.pauseButton.clicked.connect(self.pause_video)

        self.fastForwardButton = QPushButton(">>")
        self.fastForwardButton.clicked.connect(self.fast_forward)

        self.rewindButton = QPushButton("<<")
        self.rewindButton.clicked.connect(self.rewind)

        # slider that moves through the video frames
        self.slider = QSlider(Qt.Orientation.Horizontal)
        self.slider.setRange(0, 0)
        self.slider.sliderMoved.connect(self.set_position)
        self.player.durationChanged.connect(self.duration_changed)
        self.player.positionChanged.connect(self.position_changed)


        # Arrange buttons
        controlLayout = QHBoxLayout()
        controlLayout.addWidget(self.rewindButton)
        controlLayout.addWidget(self.playButton)
        controlLayout.addWidget(self.pauseButton)
        controlLayout.addWidget(self.fastForwardButton)

        # Arrange layout
        layout = QVBoxLayout()
        layout.addWidget(self.videoWidget)
        layout.addLayout(controlLayout)
        layout.addWidget(self.slider)
        self.setLayout(layout)

    # define the functions of the controls
    def set_video(self, video_path):
        url = QUrl.fromLocalFile(video_path)
        self.player.setSource(url)

    def play_video(self):
        self.player.play()

    def pause_video(self):
        self.player.pause()

    def fast_forward(self):
        self.player.setPosition(self.player.position() + 5000)  # Fast forward by 5 seconds

    def rewind(self):
        self.player.setPosition(self.player.position() - 5000)  # Rewind by 5 seconds

    def set_position(self, position):
        self.player.setPosition(position)

    def duration_changed(self, duration):
        self.slider.setRange(0, duration)

    def position_changed(self, position):
        self.slider.setValue(position)

    def set_position(self, position):
        self.player.setPosition(position)

