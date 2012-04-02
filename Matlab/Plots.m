%% Housebums plots

clear; clc; 
set(0,'DefaultFigureWindowStyle','docked');
plotpath = '../picture/';
expfig = 1;

%% Constants
w = logspace(0,3,300); % til bodeplots

%% Bodeplot of food quality as function of beers

G = tf([0.5 20 5],[0.1 2 150]);
fh1 = figure(1);
P = bodeoptions;
P.Title.String = ' '; %'Food quality as function of beers'; P.Title.FontSize = 16;
P.Xlabel.String = 'Beers/day'; P.Xlabel.FontSize = 10;
P.FreqUnits = 'Hz';
P.XlimMode = 'manual'; P.Xlim = [1 50];
bode(G,w,P)
drawnow
print(fh1, '.eps', [plotpath 'FoodQualityBeers']);

%% Plot serveret til

t = [2009 2010 2011 2012];
d = [45 105 475 515];
fh2 = figure(2);
plot(t,d)
set(gca, 'Xtick', t);
xlabel('Aar','Interpreter','LaTex')
ylabel('Antal personner','Interpreter','LaTex')
savefig(fh2,'fatsingle',plotpath,'ServeretPersonner',2)

%% Plot Døde mennesker
fh3 = figure(3);
t = [1 1000];
d = [0 0];
semilogx(t, d);
%set(gca);
xlabel('Tid','Interpreter','LaTex')
ylabel('Dead people','Interpreter','LaTex')
savefig(fh3,'fatsingle',plotpath,'DeadPeople',2)

%% Plot Sovse
fh4 = figure(4);
tid = [2009 2010 2011 2012 2013 2014];
Fernet = [0 0 1 10 80 190];
Whiskey = [0 45 60 70 150 350];
plot(tid,Fernet,tid,Whiskey);
set(gca, 'Xtick', tid);
xlabel('Tid','Interpreter','LaTex')
ylabel('Antal glade sovsemennesker','Interpreter','LaTex')
savefig(fh4,'fatsingle',plotpath,'Sovse',2)
