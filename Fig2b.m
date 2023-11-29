% This script reproduces Fig. 2b in the manuscript:
% O. M. Rosabal, O. L. A. López, H. Alves and M. Latva-aho, 
% "Sustainable RF Wireless Energy Transfer for Massive IoT: enablers and challenges," 
% in IEEE Access, doi: 10.1109/ACCESS.2023.3337214.
clc; clear;

%% Deployment details
k = 1/50;                               % PBs to devices ratio
numDev = 100;                           % number of devices
numPBs = ceil(k'*numDev);               % number of PBs

%% Hardware details
avgDevHwLife = 5:.1:40;                 % average device hardware lifetime [years]
avgBattDev = [2 3 5 10];                % average device battery lifetime [years]
avgPBConsumpt = 6/1000;                 % average PB's power consumption [kW]

avgPBEnergyConsumpt = avgPBConsumpt*...
    avgDevHwLife*365*24;                % over the devices' hw lifetime [kWh] 

instCostDev = 20;                       % installation cost per device [eur]
maintCostDev = .5*instCostDev;          % e.g., new battery, labour, recycling, etc. [eur]

instCostPB = 100;                       % per PB [eur]
energyCostGridPB = .30;                 % maintenance grid PB [eur/kWh]
energyCostBattPB = 1.5;                 % maintenance batt. PB [eur/kWh]
energyCostGreenPB = .15;                % maintenance green PB [eur/kWh]

%% Overall costs vs devices' battery lifetime

% Battery-powered IoT deployment
battReplacements = ceil(avgDevHwLife./avgBattDev') - 1;
opexPerDev = battReplacements*maintCostDev;
overallIoTCost = (instCostDev + opexPerDev)*numDev;

% Grid-powered PBs
opexPerGridPB = energyCostGridPB*avgPBEnergyConsumpt; 
overallCostGridPB = (instCostPB + opexPerGridPB).*numPBs + instCostDev*numDev;

% Battery-powered PBs
opexPerBattPB = energyCostBattPB*avgPBEnergyConsumpt;
overallCostBattPB = (instCostPB + opexPerBattPB).*numPBs + instCostDev*numDev;

% Green-powered PBs
opexPerGreenPB = energyCostGreenPB*avgPBEnergyConsumpt;
overallCostGreenPB = (instCostPB + opexPerGreenPB).*numPBs + instCostDev*numDev;

%% Plot results
figure; 
plotSettings(gcf)

semilogy(avgDevHwLife,overallIoTCost(1,:),':+k','LineWidth',1.5,...
    'MarkerIndices',[1 12 32 52 72 92 112 132 152 172 192 212 232 ...
    252 272 292 312 332 351]); hold on

semilogy(avgDevHwLife,overallIoTCost(2,:),':sk','LineWidth',1.5,...
    'MarkerIndices',[1 12 42 72 102 132 162 192 222 252 282 312 342 351]);

semilogy(avgDevHwLife,overallIoTCost(3,:),':dk','LineWidth',1.5,...
    'MarkerIndices',[2 52 102 152 202 252 302 351]);

semilogy(avgDevHwLife,overallIoTCost(4,:),':pk','LineWidth',1.5,...
    'MarkerIndices',[1 52 152 252 351]);

idxWET= [1 26 51 76 101 126 151 176 201 226 251 276 301 326 351];
WETs1 = semilogy(avgDevHwLife,overallCostGridPB,'-o','Color','#D95319','LineWidth',1.5,'MarkerIndices',idxWET);
WETs2 = semilogy(avgDevHwLife,overallCostBattPB,'-s','Color','#0072BD','LineWidth',1.5,'MarkerIndices',idxWET);
WETs3 = semilogy(avgDevHwLife,overallCostGreenPB,'-^','Color','#EDB120','LineWidth',1.5,'MarkerIndices',idxWET);
 
grid on
hold off
title('(b)','FontSize', 12, 'Interpreter', 'latex')
yticks([2e3 5e3 1e4 2e4]);
xlabel('Lifetime of devices'' hardware', 'FontSize', 14, 'Interpreter', 'latex')
ylabel(['Overall costs (' num2str(char(8364)) ')'], 'FontSize', 14, 'Interpreter', 'latex')
lgd = legend('2 year', '3 years', '5 years', '10 years', 'FontSize', 12,...
    'Position',[0.13423066297563 0.577158564814815 0.289486936381664 0.147602464737197], 'NumColumns',2, 'Interpreter', 'latex');
title(lgd,'\textbf{battery-powered devices}')

ah2=axes('position',get(gca,'position'),'visible','off');
leg2=legend(ah2,[WETs1 WETs2 WETs3],{'grid-powered PBs','battery-powered PBs','gPBs'}, 'FontSize', 12,...
    'Position', [0.133437534621931 0.729844770119861 0.34928633763317 0.189264707004323],'Interpreter','latex');
title(leg2, '\textbf{RF-WPT-enabled deployment}');