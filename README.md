## AnnotatingAccelTraces
This is the progress for creating a new script/exe for annotating accelerometer traces with the behaviour as per an associated video. This is my attempt at a recreation of the MatLab script by [Chris Clemente](https://github.com/cclemente/Animal_accelerometry), but adapted for my specific purposes. It does not have the calibration functionality that Chris' version has. 

This version can currently only accept Axivity AX3's and MP4s and also lacks error handling.

# Files
main.py -> Launches the window
MainWindow.py -> Controls the layout and slots of each element
OpenFiles.py -> Search directory for video and csv, display their names
VideoPlayer.py -> Display and control the video
DisplayAccel.py -> Plot and navigate through the accel csv
