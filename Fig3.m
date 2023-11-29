% This script can be used to reproduce the Fig. 3 in the manuscript:
% O. M. Rosabal, O. L. A. López, H. Alves and M. Latva-aho, 
% "Sustainable RF Wireless Energy Transfer for Massive IoT: enablers and challenges," 
% in IEEE Access, doi: 10.1109/ACCESS.2023.3337214.
clear; clc;

%% Simulation settings
PB = 5;             % number of PBs
alpha = 3;          % path-loss exponent
Pt = 1;             % maximum PBs' transmission power [W]

%% Devices' positions
% the spatial density of the devices' deployment changes depending on the
% quadrant.
rng default % For reproducibility
s1 = [10*rand(5,1), 10*rand(5,1)];
s2 = [-10*rand(10,1), 10*rand(10,1)];
s3 = [-10*rand(5,1), -10*rand(5,1)];
s4 = [10*rand(50,1), -10*rand(50,1)];
x_s = [s1; s2; s3; s4];

%% Solve the optimization problem (using GA)
rng default % For reproducibility
hybridopts = optimoptions('fmincon','OptimalityTolerance',1e-10);
options = optimoptions('ga','HybridFcn',{'fmincon',hybridopts});
[x_b,fval,exitflag,output,population,scores] = ga(@(x)objFnc(x_s,x,alpha,Pt), PB*2, [],[],[],[],-10*ones(PB*2,1),10*ones(PB*2,1),[],options);

%% Plot results (Fig. 3a)
fig1 = figure(1);
plotSettings(fig1);

% Available ambient energy to the PBs
[X1, X2] = meshgrid(-10:.1:10, -10:.1:10);
X1_ = reshape(X1, [numel(X1) 1]);
X2_ = reshape(X2, [numel(X2) 1]);
X = [X1_ X2_];
harvestedEnergy = ambientEHFnc(X);
harvestedEnergy = reshape(harvestedEnergy, [sqrt(numel(harvestedEnergy)) sqrt(numel(harvestedEnergy))]);
contourf(X1, X2, harvestedEnergy, 40); hold on
colormap(flipud(bone))

% PBs' optimal positions
x_b = reshape(x_b, [PBN 2]);
plot(x_b(:,1), x_b(:,2), 'x', 'Color', '#0072BD', 'MarkerSize', 10, 'LineWidth', 3)

% Devices' positions
plot(x_s(:,1), x_s(:,2), 'o', 'Color', 'k', 'MarkerFaceColor', '#D95319', 'MarkerSize', 5);

% contourf plot settings
cb = colorbar;
cb.Label.Interpreter = 'latex';
caxis([0, 8]);
set(gca, 'FontSize', 12, 'TickLabelInterpreter','latex');

% Plot annotations

% gPB_1
annotation('textbox',[0.634047110867642 0.821338137904168 0.0686456400742124 0.0588235294117645],...
    'String',{'$\mathrm{gPB}_1$'},'LineStyle','-.','Interpreter','latex',...
    'FontSize',14,'FitBoxToText','off','BackgroundColor',[0.901960784313726 0.901960784313726 0.901960784313726]);

% gPB_2
annotation('textbox',[0.266207926574021 0.385287624983768 0.0686456400742119 0.0588235294117646],...
    'String',{'$\mathrm{gPB}_2$'},'LineStyle','-.','Interpreter','latex',...
    'FontSize',14,'FitBoxToText','off','BackgroundColor',[0.901960784313726 0.901960784313726 0.901960784313726]);

% gPB_3
annotation('textbox',[0.621014878476079 0.252869757174392 0.0686456400742123 0.0588235294117645],...
    'String',{'$\mathrm{gPB}_3$'},'LineStyle','-.','Interpreter','latex',...
    'FontSize',14,'FitBoxToText','off','BackgroundColor',[0.901960784313726 0.901960784313726 0.901960784313726]);

% gPB_4
annotation('textbox',[0.312140505733818 0.649243604726657 0.0686456400742125 0.0588235294117645],...
    'String',{'$\mathrm{gPB}_4$'},'LineStyle','-.','Interpreter','latex',...
    'FontSize',14,'FitBoxToText','off','BackgroundColor',[0.901960784313726 0.901960784313726 0.901960784313726]);

% gPB_5
annotation('textbox',[0.558560420876376 0.467027009479288 0.0686456400742126 0.0588235294117644],...
    'String',{'$\mathrm{gPB}_5$'},'LineStyle','-.','Interpreter','latex',...
    'FontSize',14,'FitBoxToText','off','BackgroundColor',[0.901960784313726 0.901960784313726 0.901960784313726]);

hold off
axis equal
box on
title('(a)', 'FontSize', 12, 'Interpreter', 'latex')
xlabel('x[m]', 'FontSize', 14, 'Interpreter', 'latex')
ylabel('y[m]', 'FontSize', 14, 'Interpreter', 'latex')

%% Plot results (Fig. 3b)
fig2 = figure(2);
plotSettings(fig2);

% Available RF energy to the devices
[X1, X2] = meshgrid(-10:.1:10, -10:.1:10);
X1_ = reshape(X1, [numel(X1) 1]);
X2_ = reshape(X2, [numel(X2) 1]);
X = [X1_ X2_];
harvestedRFEnergy = RFEHFnc(x_b,X,alpha,Pt);
harvestedRFEnergy = reshape(harvestedRFEnergy, [sqrt(numel(harvestedRFEnergy)) sqrt(numel(harvestedRFEnergy))]);
contourf(X1,X2,10*log10(harvestedRFEnergy*1e3),40); hold on
colormap(flipud(bone))

% PBs' optimal positions
plot(x_b(:,1), x_b(:,2), 'x', 'Color', '#0072BD', 'MarkerSize', 10, 'LineWidth', 3)

% Devices' positions
plot(x_s(:,1), x_s(:,2), 'o', 'Color', 'k', 'MarkerFaceColor', '#D95319', 'MarkerSize', 5);

% contourf plot settings
cb = colorbar;
cb.Label.Interpreter = 'latex';
cb.Ticks = [-20 -10 0 10 20 30];
cb.TickLabels = num2cell([-20 -10 0 10 20 30]);
caxis([-20, 30]);
set(gca, 'FontSize', 12, 'TickLabelInterpreter','latex');

% Plot annotations

% worst-positioned device
annotation('ellipse',[0.413794363590487 0.795562264640955 0.0404823584936365 0.0667170479302831],...
    'LineWidth',1.5,'LineStyle','--');

% gPB_1
annotation('textbox',[0.634047110867642 0.821338137904168 0.0686456400742124 0.0588235294117645],...
    'String',{'$\mathrm{gPB}_1$'},'LineStyle','-.','Interpreter','latex',...
    'FontSize',14,'FitBoxToText','off','BackgroundColor',[0.901960784313726 0.901960784313726 0.901960784313726]);

% gPB_2
annotation('textbox',[0.266207926574021 0.385287624983768 0.0686456400742119 0.0588235294117646],...
    'String',{'$\mathrm{gPB}_2$'},'LineStyle','-.','Interpreter','latex',...
    'FontSize',14,'FitBoxToText','off','BackgroundColor',[0.901960784313726 0.901960784313726 0.901960784313726]);

% gPB_3
annotation('textbox',[0.621014878476079 0.252869757174392 0.0686456400742123 0.0588235294117645],...
    'String',{'$\mathrm{gPB}_3$'},'LineStyle','-.','Interpreter','latex',...
    'FontSize',14,'FitBoxToText','off','BackgroundColor',[0.901960784313726 0.901960784313726 0.901960784313726]);

% gPB_4
annotation('textbox',[0.312140505733818 0.649243604726657 0.0686456400742125 0.0588235294117645],...
    'String',{'$\mathrm{gPB}_4$'},'LineStyle','-.','Interpreter','latex',...
    'FontSize',14,'FitBoxToText','off','BackgroundColor',[0.901960784313726 0.901960784313726 0.901960784313726]);

% gPB_5
annotation('textbox',[0.558560420876376 0.467027009479288 0.0686456400742126 0.0588235294117644],...
    'String',{'$\mathrm{gPB}_5$'},'LineStyle','-.','Interpreter','latex',...
    'FontSize',14,'FitBoxToText','off','BackgroundColor',[0.901960784313726 0.901960784313726 0.901960784313726]);

hold off
axis equal
box on
title('(b)', 'FontSize', 12, 'Interpreter', 'latex')
xlabel('x[m]', 'FontSize', 14, 'Interpreter', 'latex')
ylabel('y[m]', 'FontSize', 14, 'Interpreter', 'latex')