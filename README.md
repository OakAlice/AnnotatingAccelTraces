## AnnotatingAccelTraces
This is the progress for creating a new script/exe for annotating accelerometer traces with the behaviour as per an associated video. This is my attempt at a recreation of the MatLab script by [Chris Clemente](https://github.com/cclemente/Animal_accelerometry), but adapted for my specific purposes. It is under construction.

### MatLab
Updating the original MatLab script, with limited changes.


### Python
Creating a new program.
* main.py -> Launches the window
* MainWindow.py -> Controls the initialisation and connections of each element
* LayoutManager.py -> Overall layout of the widgets
* OpenFiles.py -> Search directory for video and csv, display their names
* VideoPlayer.py -> Display and control the video
* DisplayAccel.py -> Plot and navigate through the accel csv
* BehaviourButtons.py -> Create, name, and colour buttons
