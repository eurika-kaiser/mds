function plot2D(Data, options)

fhandle = figure('visible','on');
set(gca,'position',[0.2 0.2 0.75 0.75])

%% Parameters
Labels        = Data.labels;
nGen          = size(Data.X,3);
if isfield(Data,'cmap')
    CMap      = Data.cmap;
else
    CMap      = zeros(nGen,3);
end

TextSize      = 12;
LineWidth_Box = 1;
LineWidth     = 1;
units         = 'centimeter';
FigureBox     = 10;
MarkerSize    = 3;
dpi_r         = 300;

%% Figure
hold on
box on

% Set color map
colormap(CMap);

% Determine Axes
xMin = min(min([Data.X(:,1,:)]));
xMax = max(max([Data.X(:,1,:)]));
yMin = min(min([Data.X(:,2,:)]));
yMax = max(max([Data.X(:,2,:)]));

dx   = 0.05*(xMax-xMin);
dy   = 0.05*(yMax-yMin);
xMin = xMin - dx;
xMax = xMax + dx;
yMin = yMin - dy;
yMax = yMax + dy;


% Plot data points
for j = 1:nGen
    h(j) = plot(squeeze(Data.X(:,1,j)), squeeze(Data.X(:,2,j)),'o', ...
        'MarkerSize',MarkerSize, 'LineWidth',LineWidth, ...
        'Color', CMap(j,:), 'MarkerFaceColor', CMap(j,:));
    entries{j} = [num2str(j)];
end

if isfield(Data,'axis')
    axis(Data.axis)
else
    axis([xMin xMax yMin yMax])
end

set(gca, 'Fontsize', TextSize,'LineWidth',LineWidth_Box);
if all(Labels==1)
    title(options.title, 'Fontsize', TextSize)
else
    if size(c1_Centers,3) <= 5
        legend(h,entries,'Location','NorthOutside', 'orientation', 'horizontal')
    else
        legend(h,entries,'Location','EastOutside', 'orientation', 'vertical')
    end
end

set(gcf, 'PaperUnits', units, ...
    'PaperPosition', [0 0 FigureBox FigureBox]);
xlabel(options.xname, 'Fontsize', TextSize)
ylabel(options.yname, 'Fontsize', TextSize)

file_str = [options.filename];

print(fhandle,'-dpng',file_str);
print(fhandle,'-depsc2',sprintf('-r%d',dpi_r),file_str); %,'-cmyk',file_str
print(fhandle,'-dpdf',  file_str);
system(['pdfcrop ', file_str, '.pdf ', file_str, '.pdf']);

close(fhandle)
end
