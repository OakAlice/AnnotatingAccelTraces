from PyQt6.QtWidgets import (QPushButton, QRadioButton, QLabel, QColorDialog, 
                             QLineEdit, QVBoxLayout, QWidget, QGridLayout, 
                             QDialog, QDialogButtonBox, QApplication)
from PyQt6.QtCore import Qt
from PyQt6.QtGui import QColor
from PyQt6.QtCore import pyqtSignal

class NewButton(QWidget):
    newBehaviourAdded = pyqtSignal(str, QColor)  # Signal emitting
    def __init__(self):
        super().__init__()
        self.initUI()
       # self.newBehaviourAdded = pyqtSignal(str, QColor)  # Signal emitting


    def initUI(self):
        self.layout = QGridLayout(self)

        self.newButton = QPushButton("+ New")
        self.newButton.clicked.connect(self.makeNewButton)
        self.layout.addWidget(self.newButton, 0, 0)  # Place the "+ New" button at the top-left

        self.buttonCount = 1  # Keep track of the number of buttons added

    def makeNewButton(self):
        dialog = NewButtonDialog(self)
        if dialog.exec():
            behavior_name, color = dialog.getInputs()
            self.addBehaviourButton(behavior_name, color)

    def addBehaviourButton(self, name, color):
        new_button = QRadioButton(name)
        new_button.setStyleSheet(f"QRadioButton {{ color: {color.name()} }}")
    
        row = self.buttonCount // 10  # Guess buttons per row
        col = self.buttonCount % 10
        self.layout.addWidget(new_button, row, col)
        self.buttonCount += 1
        self.newBehaviourAdded.emit(name, color)  # Emit the signal

class NewButtonDialog(QDialog):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setWindowTitle("Add New Behaviour")
        self.layout = QVBoxLayout(self)

        message = QLabel("Please select new behaviour")
        self.enterName = QLineEdit()
        self.enterName.setPlaceholderText("Enter behaviour name...")

        self.colorButton = QPushButton("Select Color")
        self.colorButton.clicked.connect(self.selectColor)
        self.selectedColor = QColor(Qt.GlobalColor.black)

        QBtn = QDialogButtonBox.StandardButton.Ok | QDialogButtonBox.StandardButton.Cancel
        self.buttonBox = QDialogButtonBox(QBtn)
        self.buttonBox.accepted.connect(self.accept)
        self.buttonBox.rejected.connect(self.reject)

        self.layout.addWidget(message)
        self.layout.addWidget(self.enterName)
        self.layout.addWidget(self.colorButton)
        self.layout.addWidget(self.buttonBox)

    def selectColor(self):
        color = QColorDialog.getColor()
        if color.isValid():
            self.selectedColor = color

    def getInputs(self):
        return self.enterName.text(), self.selectedColor

if __name__ == '__main__':
    app = QApplication([])
    mainWin = NewButton()
    mainWin.show()
    app.exec()
