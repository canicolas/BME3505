%% MATLAB: Data Analysis

% this code does not calculate strain at failure and toughness
% you need to add few more instructions to calculate these values
clear; close all; clc;


%% Given data:
fileName = 'Specimen_RawData_1.csv';


%% Extract the specimen dimensions from .csv file  

header = readHeader(fileName);

% celldisp(header1.properties);
SpecimenLabel = header.specimenLabel;
Width = header.values(2);
Thickness = header.values(3);
L = header.values(4); % length

% Calculate the cross-sectional area
A = Width*Thickness;

% if the file header has a different format, you need to modify readHeader.m
% or define L and A here as seen below
% L = 96; A = 42.75; 


%% Read Data from .csv file
data = readMyData(fileName);
%  The format of data in my file: "0.00000","0.00000","1.17556","0.00000","0.04898"
% if your data file does not include "number", you can use dlmread or xlsread.


%% Define the variables of interest
t = data(:,1);
u = data(:,2); 
F = data(:,3); 

%% Plotting data

figure
subplot(3,1,1)
plot(t,u); grid
xlabel('time(s)')
ylabel('extension (mm)')
title(SpecimenLabel);

subplot(3,1,2)
plot(t,F); grid
xlabel('time(s)')
ylabel('Force(N)')

subplot(3,1,3)
plot(u,F); grid
xlabel ('extension(mm)')
ylabel('Force(N)')
title('Force - extension curve')

% Data zeroing - if necessary
% u = u - u(1);
% F = F - F(1);



%% Convert Force - extension  to stress-strain 
stress = F/A;
e = u/L;


%% Plot stress-strain curve
fig10 = figure;
h1 = subplot(3,1,1);
plot(e,stress); grid; 
xlabel('strain'); ylabel('stress(units)')
hold on
title(SpecimenLabel);


%% Find max stress
[UTS1, idxUTS1]=max(stress);
disp(['Max stress = ', num2str(UTS1), ' units']);
plot(e(idxUTS1), UTS1, '*r')


%% Use a moving window to identify the slope

%!!! Specify the parameters of function movingSlope 
W = 20;% !!! size of moving window; select a value for W which best fits your data
step = 5; % the same for step 

% Plot the first and the last windows 
wH = max(stress)/5; % the height of the first window - needed just for plotting
hold on;
plot([e(1) e(W) e(W) e(1)], [0 0 wH wH], 'm') 
plot([e(end-W) e(end) e(end) e(end-W) e(end-W)], [0 0 max(stress) max(stress) 0], 'm') 


%% Find the slope

[eW, slope, intercept] = movingSlope(e,stress,W, step); 

% Remove the negative part of the slope
eW(slope<0) = [];
slope(slope<0) = [];

% Plot the slope
h2 = subplot(3,1,2);
plot(eW,slope); grid; % plot the slope
xlabel('strain(units)'); ylabel('slope(units)'); legend('slope values')


%% Find the maximum slope and its index

[maxSlope, idx_maxSlope]=max(slope); 
e_maxSlope = eW(idx_maxSlope); % find value of the strain corresponding to max slope

title(['Max Slope(MTM) = ', num2str(maxSlope), ' units'])
disp(['Max Slope(MTM) = ', num2str(maxSlope), ' units'])

%% Plot a trend line with the slope maxSlope at the location of max slope
% to plot the line you need the slope and the intercept

h3 = subplot(3,1,3);
plot(e,stress); grid; % plot stress-strain
xlabel('strain'); ylabel('stress(units)')
hold on

intercept_trendLine = intercept(idx_maxSlope);

disp('**********************')
beep
disp('From subplot 3 provide strain limits for linear region')
disp('Example [eL_start, eL_end] = [0.15 0.25]')

eL_bounds = input('[eL_start, eL_end] = '); 
eL = e(e>eL_bounds(1) & e<eL_bounds(2)); % L = linear region

trendLine = maxSlope*eL + intercept_trendLine;

plot(eL, trendLine, '-k') % plot the line


lineEq = [num2str(maxSlope),'*strain + ',num2str(intercept_trendLine)];
legend('experimental data', lineEq , 'Location','southeast')

linkaxes([h1 h2],'x'); 


%% Evaluate the goodness of fit 
% for R2 see the code from Part 1

