%% Example:bilinearFitting - find the slope of a bilinear curve
clear; clc; close all;

s1=2;
s2=4;

%% Generate data
x1=[0:0.05:2]; 
x2=[2.05:0.05:4];

y1=x1.*s1;
y2=x2.*s2-4;


%% Create unique variables
x=[x1, x2];
y=[y1, y2];


%% Plot data
