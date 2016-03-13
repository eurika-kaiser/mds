clear all, close all,

% Include path to src
addpath('../src/');

% Load example data
SquaredDistanceMatrix = load('D2.mat');

% Example matrix consists of squared distances
% Algorithm requires distances
DistanceMatrix = sqrt(SquaredDistanceMatrix.CDM);

% Classical multidimensional scaling method
X = cmds(DistanceMatrix,2);

% Plot results
figure,plot(X(:,1),X(:,2),'.')

% Do a nicer plot and save it
Data2plot.labels = ones(size(X,1),1);
Data2plot.X      = X;
options.xname    = '\gamma_1';
options.yname    = '\gamma_2';
options.title    = '2D plot';
options.filename = 'output/2Dplot';
mkdir('output')
plot2D(Data2plot, options)
