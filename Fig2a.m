% This script reproduces the Fig. 2a in the manuscript:
% O. M. Rosabal, O. L. A. López, H. Alves and M. Latva-aho, 
% "Sustainable RF Wireless Energy Transfer for Massive IoT: enablers and challenges," 
% in IEEE Access, doi: 10.1109/ACCESS.2023.3337214.
clear; clc;

%% Deployment details
k = 1/50;                               % PBs to devices ratio
numDev = linspace(1,1e4,1e4);           % number of devices
numPBs = ceil(k'*numDev);               % number of PBs

%% Hardware details
avgDevHwLife = 15;                      % average IoT device hardware lifetime [years]
avgBattDev = 5;                         % average IoT device battery lifetime [years]
avgPBConsumpt = 6/1000;                 % average PB's power consumption [kW]

avgPBEnergyConsumpt = avgPBConsumpt*...
    avgDevHwLife*365*24;                % PB's energy consumption over devices' hw lifetime[kWh]

instCostDev = 20;                       % installation cost per device [eur]
maintCostDev = .5*instCostDev;          % e.g., new battery, labour, recycling, etc. [eur]

instCostPB = 100;                       % per PB [eur]
energyCostGridPB = .30;                 % maintenance grid PB [eur/kWh]
energyCostBattPB = 1.5;                 % maintenance batt. PB [eur/kWh]
energyCostGreenPB = .15;                % maintenance green PB [eur/kWh]

%% Overall costs vs number of deployed devices

% Battery-powered IoT deployment
battReplacements = ceil(avgDevHwLife/avgBattDev) - 1;
opexPerDev = battReplacements*maintCostDev;
overallIoTCost = (instCostDev + opexPerDev)*numDev;

% Grid-powered PBs
opexPerGridPB = energyCostGridPB*avgPBEnergyConsumpt; 
totalCostGridPB = (instCostPB + opexPerGridPB).*numPBs + instCostDev*numDev;

% Battery-powered PBs
opexPerBattPB = energyCostBattPB*avgPBEnergyConsumpt;
totalCostBattPB = (instCostPB + opexPerBattPB).*numPBs + instCostDev*numDev;

% Green-powered PBs
opexPerGreenPB = energyCostGreenPB*avgPBEnergyConsumpt;
totalCostGreenPB = (instCostPB + opexPerGreenPB).*numPBs + instCostDev*numDev;
 
%% Plot results
figure 
plotSettings(gcf)
idxMarkers = [10 25 50 100 250 500 1e3 25e2 5e3 1e4];

p1 = loglog(numDev, totalCostGridPB,'-o','Color','#D95319','LineWidth',1.5,'MarkerIndices',idxMarkers); hold on
p2 = loglog(numDev,totalCostBattPB,'-s','Color','#0072BD','LineWidth',1.5,'MarkerIndices',idxMarkers);
p3 = loglog(numDev,totalCostGreenPB,'-^','Color','#EDB120','LineWidth',1.5,'MarkerIndices',idxMarkers); 
p4 = loglog(numDev,overallIoTCost,':+k','LineWidth',1.5,'MarkerIndices',idxMarkers);

hold off
grid on
box on
title('(a)', 'FontSize', 12, 'Interpreter', 'latex')
set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'Fontsize', 12)
ylim([300 7e5])
xlim([1e1 1e4])
xlabel("Number of connected devices", 'FontSize', 14, 'Interpreter', 'latex')
ylabel(['Overall costs (' char(8364) ')'], 'FontSize', 14, 'Interpreter', 'latex')
legend([p1 p2 p3 p4], {'grid-powered PBs', 'battery-powered PBs', 'gPBs', 'battery-powered devices'' deployment'},...
    'FontSize', 12, 'Location', 'northwest', 'Interpreter', 'latex')