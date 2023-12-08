from PyQt6.QtWidgets import QMainWindow
from LayoutManager import LayoutManager
from OpenFiles import FileSelection, OpenFileSignals
from DisplayAccel import read_and_process_csv

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        
        # set the title
        self.setWindowTitle("AnnotatingAccelTraces V2")

        # Initialize variables at default values
        self.isPlaying = False
        self.videoStartTime = 0
        self.max_video_duration = 1  # Avoid division by zero

        # Initialize LayoutManager where all widgets are intialised
        self.layoutManager = LayoutManager()
        self.setCentralWidget(self.layoutManager)

        # Initialise file selection and signals variables
        self.fileSelectionSignals = OpenFileSignals()
        self.openFiles = FileSelection(self.fileSelectionSignals)

        # Connect signals to slots
        # Connect file loading buttons: when buttons are clicked, browse is opened and file name is extracted
        self.layoutManager.loadVidButton.clicked.connect(
            lambda: self.openFiles.open_file_dialog(self, self.layoutManager.videoLabel, None, self.layoutManager.loadVidButton)
        )
        self.layoutManager.loadCsvButton.clicked.connect(
            lambda: self.openFiles.open_file_dialog(self, None, self.layoutManager.csvLabel, self.layoutManager.loadCsvButton)
        )

        # Connect file selection signals to the video player and plot widget
        self.fileSelectionSignals.videoSelected.connect(self.layoutManager.videoPlayer.set_video)
        self.fileSelectionSignals.csvSelected.connect(self.load_csv_and_plot)

        # Connect the VideoPlayer's durationChanged signal to update the durationLabel
        self.layoutManager.videoPlayer.durationChanged.connect(self.layoutManager.update_duration_label)

        # Connect the FrameRate spin boxes to the rate syncing calculator
        self.layoutManager.videoFrameRate.valueChanged.connect(self.update_sync_factor)
        self.layoutManager.csvFrameRate.valueChanged.connect(self.update_sync_factor)

    # functions
    def load_csv_and_plot(self, csv_path): # load CSV data and update the plot widget
        df = read_and_process_csv(csv_path)
        self.layoutManager.plotWidget.load_data(df)

    def update_sync_factor(self): # synchronisation rate between csv and video
        video_fps = self.layoutManager.videoFrameRate.value()
        csv_fps = self.layoutManager.csvFrameRate.value()
        if video_fps > 0 and csv_fps > 0:
            self.sync_factor = video_fps / csv_fps
        else:
            self.sync_factor = 1  # Default value to avoid division by zero
    
    def on_video_play(self):
        self.isPlaying = True

    def on_video_pause(self):
        self.isPlaying = False
