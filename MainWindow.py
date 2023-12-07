from PyQt6.QtWidgets import QMainWindow
from LayoutManager import LayoutManager
from OpenFiles import FileSelection, OpenFileSignals

from DisplayAccel import read_and_process_csv

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("AnnotatingAccelTraces V2")

        # Initialize file selection and signals
        self.fileSelectionSignals = OpenFileSignals()
        self.openFiles = FileSelection(self.fileSelectionSignals)

        # Initialize LayoutManager
        self.layoutManager = LayoutManager()
        self.setCentralWidget(self.layoutManager)

        # Connect file loading buttons
        self.layoutManager.loadVidButton.clicked.connect(
            lambda: self.openFiles.open_file_dialog(self, self.layoutManager.videoLabel, None, self.layoutManager.loadVidButton)
        )
        self.layoutManager.loadCsvButton.clicked.connect(
            lambda: self.openFiles.open_file_dialog(self, None, self.layoutManager.csvLabel, self.layoutManager.loadCsvButton)
        )

        # Connect file selection signals to video player and plot widget
        self.fileSelectionSignals.videoSelected.connect(self.layoutManager.videoPlayer.set_video)
        self.fileSelectionSignals.csvSelected.connect(self.load_csv_and_plot)

    def load_csv_and_plot(self, csv_path):
        # This method will load CSV data and update the plot widget
        # Assuming read_and_process_csv is a function that returns a DataFrame
        df = read_and_process_csv(csv_path)
        self.layoutManager.plotWidget.load_data(df)
