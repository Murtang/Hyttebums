function savefig(figure_handle, preset, figpath, filename, export)
% SAVEFIG saves figure to pdf
%   savefig(figure_handle, preset, figpath, name[, export]) saves the figure
%   given by figure_handle with layout given by preset to figpath/filename.pdf.
% Arguments:
%   figure_handle: Handle to the figure to be saved
%   preset:        Layout preset (see sec. "Presets" in the code)
%   figpath:       Path to directory to save in ('' for current dir)
%   filename:      Filename without extension
%   export:        0: do nothing, 1: layout but no print, 2: layout and print

%% Check export
if nargin < 5
  export = 2;
else
  if ~export
    return
  end
end

%% Handles

handles        = flipud(findobj(figure_handle, 'Type', 'axes'));
legend_handles = findobj(figure_handle, 'Type', 'axes', 'Tag', 'legend');
axes_handles   = handles(~ismember(handles, legend_handles));

%% Presets

% Default values (in cm)
xdim      = 21;         % Paper width
lm        = 3;          % Left margin
rm        = 3;          % Right margin
bm        = 1;          % Bottom margini
tm        = .2;         % Top margin
width     = xdim-lm-rm; % Width of plot
height    = 4;          % Heigth of plot

% Positions (matrix of axes positions)
%   subplot 1: [x y width height ;...
%   subplot 2:  x y width height ;...
%                                 ...
%   subplot n:  x y width height];
% x and y coordinates start from lower left corner
positions = [lm bm width height];

% Legends to put above plots
legends_above = legend_handles;

switch preset
  case 'single'
  case 'fatsingle'
    height    = 6.5;
    positions = [lm bm width height];
  case 'fatfatsingle'
    height    = 9;
    positions = [lm bm width height];
  case 'fatsinglecbar'
    height    = 6.5;
    xsep      = .2;
    cwidth    = .5;
    positions = [lm            bm  width height;
                 lm+width+xsep bm cwidth height];
  case 'bode'
    sep       = 0.4;
    positions = [lm bm+height+sep width height ;...
                 lm bm            width height];
    set(axes_handles(1), 'XTickLabel', '');
    legends_above = min(legend_handles);
  case '1x2'
    sep       = 1.1;
    positions = [lm bm+height+sep width height ;...
                 lm bm            width height];
    legends_above = min(legend_handles);
  case '1x4'
    heigth    = 2;
    sep       = 0.3;
    positions = [lm bm+3*(height+sep) width height ;...
                 lm bm+2*(height+sep) width height ;...
                 lm bm+height+sep width height ;...
                 lm bm            width height];
    set(axes_handles(1), 'XTickLabel', '');
    set(axes_handles(2), 'XTickLabel', '');
    set(axes_handles(3), 'XTickLabel', '');
    legends_above = min(legend_handles);
  case '2x2'
    lm        = 2;
    heigth    = 4;
    xsep      = 0.6;
    ysep      = 0.4;
    width     = (xdim-lm-rm-xsep)/2;
    positions = [lm bm+heigth+ysep width heigth ; lm+width+xsep bm+heigth+ysep width heigth ;...
                 lm bm             width heigth ; lm+width+xsep bm             width heigth];
    set(axes_handles(1), 'XTickLabel','');
    set(axes_handles(2), 'XTickLabel','',...
                         'YTickLabel','');
    set(axes_handles(4), 'YTickLabel','');
  case '2x2s'
    lm        = 2;
    heigth    = 4;
    xsep      = 0.6;
    ysep      = 1;
    width     = (xdim-lm-rm-xsep)/2;
    positions = [lm bm+heigth+ysep width heigth ; lm+width+xsep bm+heigth+ysep width heigth ;...
                 lm bm             width heigth ; lm+width+xsep bm             width heigth];
    set(axes_handles(1), 'XTickLabel','');
    set(axes_handles(2), 'XTickLabel','',...
                         'YTickLabel','');
    delete(get(axes_handles(2),'YLabel'));
    delete(get(axes_handles(4),'YLabel'));
    set(axes_handles(4), 'YTickLabel','');
  case '3x3'
    lm        = 2;
    h         = 4;
    xsep      = 1;
    ysep      = 1.1;
    w         = (xdim-(lm+rm)-2*xsep)/3;
    positions = [lm bm+2*(h+ysep) w h ; lm+w+xsep bm+2*(h+ysep) w h ; lm+2*(w+xsep) bm+2*(h+ysep) w h ;...
                 lm bm+h+ysep     w h ; lm+w+xsep bm+h+ysep     w h ; lm+2*(w+xsep) bm+h+ysep     w h ;...
                 lm bm            w h ; lm+w+xsep bm            w h ; lm+2*(w+xsep) bm            w h ];
    delete(cell2mat(get(handles([2 3 5 6 8 9]),'YLabel')));
    set(handles([2 3 5 6 8 9]),'YTickLabel','');
  otherwise
    error('Unknown plotting preset');
end

%% Derived parameters

naxes = size(positions, 1);
ydim = positions(1, 2) + positions(1, 4) + tm;

%% Error check

%if length(axes_handles) ~= naxes
%  error('Mismatch in number of axes and preset');
%end

%% Legend

if ~isempty(legends_above)
  legend_height = 0.8;
  for i = 1:length(legends_above)
    legend_text = get(legends_above(i), 'String');
    legends_above(i) = legend(legends_above(i), 'String', legend_text, 'Location', 'NorthOutside', 'Orientation', 'horizontal');
  end
  ydim = ydim + legend_height;
end

% Set legends vertical if too long (not working)
%if ~isempty(legends_above)
%  legend_first_line_height = 0.8;
%  legend_extra_line_height = 0.4;
%  legend_height = legend_first_line_height;
%  for i = 1:length(legends_above)
%    legend_text = get(legends_above(i), 'String');
%    legends_above(i) = legend(legends_above(i), 'String', legend_text, 'Location', 'NorthOutside', 'Orientation', 'horizontal');
%    legends_above_position(i,:) = get(legends_above(i), 'Position');
%    if legends_above_position(i,3) > 1
%      warning('Legend too long. Making multiline legend');
%      legends_above(i) = legend(legends_above(i), 'String', legend_text, 'Location', 'NorthOutside', 'Orientation', 'vertical');
%      current_legend_height = legend_first_line_height+(size(legend_text, 2)-1)*legend_extra_line_height;
%      if legend_height < current_legend_height
%        legend_height = current_legend_height;
%      end
%    end
%  end
%  ydim = ydim + legend_height;
%end

%% Paper setup

set(figure_handle,'PaperUnits', 'centimeters');
set(figure_handle,'PaperSize', [xdim ydim]);
set(figure_handle,'PaperPositionMode', 'manual');
set(figure_handle,'PaperPosition', [0 0 xdim ydim]);

%% Position

for i = 1:naxes
  set(axes_handles(i), 'position', positions(i,:)./[xdim ydim xdim ydim]);
end

%% Save to pdf-file

% Check if figpath ends with /
if ~isempty(figpath) && ~strcmp(figpath(end),'/')
  figpath(end+1) = '/';
end

% Check if directory exist
if ~isempty(figpath) && ~exist(figpath,'dir')
  error('Output directory does not exist, please check figpath')
end

if export == 2
  drawnow
  print(figure_handle, '-dpdf', [figpath filename]);
end
