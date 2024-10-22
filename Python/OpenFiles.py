from PyQt6.QtWidgets import QFileDialog
from PyQt6.QtCore import QObject, pyqtSignal
from pathlib import Path

from VideoPlayer import VideoPlayer

class OpenFileSignals(QObject):
    videoSelected = pyqtSignal(str)
    csvSelected = pyqtSignal(str)

class FileSelection:
    def __init__(self, signals):
        self.signals = signals

    def open_file_dialog(self, parent, video_label, csv_label, sender):
        dialog = QFileDialog(parent)

        if sender.text() == "Browse Video":  # Check button text to determine filter
            dialog.setNameFilter("Video (*.MP4)")
        elif sender.text() == "Browse CSV":
            dialog.setNameFilter("CSV (*.csv)")

        dialog.setFileMode(QFileDialog.FileMode.ExistingFiles)
        dialog.setViewMode(QFileDialog.ViewMode.List)

        if dialog.exec():
                filenames = dialog.selectedFiles()
                if filenames:
                    filename_only = Path(filenames[0]).name

                    if sender.text() == "Browse Video" and video_label is not None:
                        video_label.setText(filename_only)
                        video_path = filenames[0]
                        self.signals.videoSelected.emit(video_path)  # Emit the signal here
                    elif sender.text() == "Browse CSV" and csv_label is not None:
                        csv_label.setText(filename_only)
                        csv_path = filenames[0]
                        self.signals.csvSelected.emit(csv_path) # same but for csv