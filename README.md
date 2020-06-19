# EPO 4 Final Challange

![Matlab 2020a](https://img.shields.io/badge/matlab-R2020a%20tested-green)
![Windows 10](https://img.shields.io/badge/windows%2010-supported-green)
![Linux](https://img.shields.io/badge/linux-not%20supported-red)
![macOS](https://img.shields.io/badge/macos-not%20supported-red)
[![time tracker](https://wakatime.com/badge/github/KevinvdT/EPO4.svg)](https://wakatime.com/badge/github/KevinvdT/EPO4)

## Requirements

- Windows 10 (older versions of Windows might work, but are not tested)
- <span style='font-variant: small-caps;'>Matlab</span> (tested on version 2020a)
- <a href='https://nl.mathworks.com/products/signal.html'><span style='font-variant: small-caps;'>Matlab</span> Signal Processing Toolbox</a>
- <a href='https://www.mathworks.com/products/audio.html'><span style='font-variant: small-caps;'>Matlab</span> Audio Toolbox</a>
- [Matlab Navigation Toolbox](https://nl.mathworks.com/products/navigation.html)
- [Matlab Image Processing Toolbox](https://www.mathworks.com/products/image.html)
- <a href='https://www.mathworks.com/matlabcentral/fileexchange/50040-jebej-matlabwebsocket'><span style='font-variant: small-caps;'>Matlab</span> Websockets</a>
- [Node.js](https://nodejs.org/)

## Installation

Make sure that you are using a Windows 10 PC with Matlab 2020a installed, including the Signal Processing, Audio, Navigation, and Image Processing Toolboxes.

Install Matlab Websockets using the instructions in [its readme file](./Matlab/MatlabWebSocket/README.md).

Unless already installed, [download](https://nodejs.org/en/) and install Node.js. (We recommand version 12.18.1 LTS.)
Verify that it is installed correctly by running the command below in a command line:

    node --version

If Node.js is installed correctly, this will print:

    v12.18.1

(or another version number.)

## Usage

Open Matlab

    cd Matlab
    matlab .

Run `start` ([start.m](./Matlab/start.m)) in the Matlab Command Window.

> If Matlab gives the error `Address already in use: bind`:
> <br>Please restart Matlab.
