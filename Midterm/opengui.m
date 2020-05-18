% Open the GUI
guiFilePath = fullfile(getenv('APPDATA'), '..', 'Local', 'Programs', 'electron-react-boilerplate', 'ElectronReact.exe');
if isfile(guiFilePath)
    system([guiFilePath ' &']);
else
    system('EPO4GUI.exe');
end