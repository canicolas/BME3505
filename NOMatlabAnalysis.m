clear all;
close all;

filename= input('Name of the file: ','s');
data= readMyData(filename);

%% Variables
 t = data(:,1);
 d= data(:,2);
 f = data(:,3); 
 
 %% Plot
 figure
 subplot(3,1,1)
 plot (t,d)
 xlabel('Time[s]')
 ylabel('extension[mm]')
 
 subplot (3,1,2)
 plot(t, f)
 xlabel('Time[s]')
 ylabel('force[N]')
 
 subplot (3,1,3)
 plot(d, f)
 xlabel('extension[mm]')
 ylabel('force[N]')
 
 %% Analysis
 
 %%zero data
 d1= d- d(1); 
 f1= f; 
 
 figure 
 plot(d1,f1)
 xlabel ('extension [mm]')
 ylabel('force[n]')
 
 
 %%Max Val of Fd curve
 [MaxF, idxMaxF]= max(f1);
 hold on
 plot(d1(idxMaxF),MaxF, '*r')
 
 %%%Extract data to be analyzed
idxL= find(d1>0.3 &d1<3.0);
%%%%lin region
dL= d1(idxL);
fL= f1(idxL);
plot(dL,fL,'g')
%%%%Lin fit
p= polyfit(dL,fL,1);
p1= p(1); 
p2= p(2); 
%%%%Check fit
F_predicted = p1*dL+p2;
plot(dL, F_predicted,'m');
legend('measured data','max F','data for fitting','predicted values')
%%%%Eval Goodness of Fit
SStot= sum((fL-mean(fL)).^2); 
SSres = sum((fL- F_predicted).^2);
R2= 1-SSres/SStot;
%%%%The model
equ= sprintf('F= %.2f*d +%.2f \n    R2= %.2f', p1, p2, R2); 
text(10, 200, equ)


%% Determine the slope




