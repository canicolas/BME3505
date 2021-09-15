function [x_slope, slope, intercept]=movingSlope(x,y,W,step)

% x = xdata; y = ydata
% step = Moving increment 
% W = Window size 

xW = x(1:W); i = 0;

while i*step <= length(x)-W-1
    xW = x(i*step+1 : i*step+1+W);
    yW = y(i*step+1 : i*step+1+W);
    
    % polyfit is faster than fit
    p = polyfit(xW,yW,1);
    slope(i+1) = p(1);
    intercept(i+1) = p(2);
    x_slope(i+1) = (xW(1)+xW(end))/2; % middle of the window
    i = i+1;
end
