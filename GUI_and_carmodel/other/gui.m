close all;
% delete(findall(0));

figWidth = 1000;
figHeight = 500;
fig = uifigure;
fig.Position = [500 500 figWidth figHeight];

h = uihtml(fig);
h.Position = [0 0 figWidth figHeight];
h.HTMLSource = fullfile(pwd, 'epo4frontend', 'build', 'index.html');
h.DataChangedFcn = @(src, event) disp(h.Data);
% h.HTMLSource = 'gui.html';
