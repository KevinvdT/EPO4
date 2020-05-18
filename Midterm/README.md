# EPO 4 Midterm Challenge

## Requirements

- Windows 10 (other OS might work but is not tested)
- <span style='font-variant: small-caps;'>Matlab</span> (tested on version 2020a)
- <a href='https://www.mathworks.com/matlabcentral/fileexchange/50040-jebej-matlabwebsocket'><span style='font-variant: small-caps;'>Matlab</span> Websockets</a>
- <a href='https://nl.mathworks.com/products/signal.html'><span style='font-variant: small-caps;'>Matlab</span> Signal Processing Toolbox</a>
- <a href='https://www.mathworks.com/products/audio.html'><span style='font-variant: small-caps;'>Matlab</span> Audio Toolbox</a>

For the unpackaged GUI app (you can skip this, it should be embedded inside GUI.exe):

- Node
- Yarn

## Getting Started

> Make sure Matlab 2020a and the Signal Processing toolbox are installed and that you are running Windows 10.

> Make sure the Matlab Websockets package is installed. The package includes a [readme-file](./MatlabWebSocket/README.md) on how to install it.

Open Matlab and run `start` ([start.m](./start.m)) in the Command Window.

To stop, close the GUI window, and run `stop` ([stop.m](./stop.m)) in the Matlab Command Window.

> If Matlab gives the error `Address already in use: bind`, please close the GUI window (if open) and restart Matlab.
