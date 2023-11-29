% This script can reproduce Fig. 6 in the manuscript: 
% O. M. Rosabal, O. L. A. López, H. Alves and M. Latva-aho, 
% "Sustainable RF Wireless Energy Transfer for Massive IoT: enablers and challenges," 
% in IEEE Access, doi: 10.1109/ACCESS.2023.3337214.
clear; clc;

%% Simulation settings
lambda = logspace(-4,0,30);         % HPPP density [tx/m^2]
M = 4;                              % number of receiver antennas
xi = 1;                             % EH threshold [mW]
Phi = -angle(dftmtx(M));            % phase shift matrix (RF combining)
MCruns = 1e6;                       % Monte Carlo iterations

% Sigmoidal RF-EH transfer function
g = @(x) 1.61*(1-exp(-1.014*x))./(1+exp(-1.014*(x-0.4306)));    % [mW]-->[mW]

%% Monte Carlo loop

% Memory allocation
outSingleAntennaRFEH = zeros(numel(lambda),1);
outDCComb = zeros(numel(lambda),1);
outRFComb = zeros(numel(lambda),1);

for ii = 1:numel(lambda)
    outSingleAntennaRFEH_ = 0;
    outDCComb_ = 0;
    outRFComb_ = 0;
    for mc = 1:MCruns

        % Tx deployment
        Area = 100/lambda(ii);
        R = sqrt(Area/pi);
        K = poissrnd(100);
    
        d = sqrt(rand(K,1)*(R)^2);
        a = 2*pi*rand(K,1);    
        
        % Tx power
        p = 900*rand(K,1) + 100;        % [mW]
    
        % channel realizations
        beta = max(d,1).^(-2.7);
        h = zeros(M,K);
        for kk = 1:K
            h(:,kk) = sqrt(p(kk)*beta(kk))*exp(-1i*pi*(0:M-1)'*sin(a(kk)));
        end
                
        % outage probability
        outSingleAntennaRFEH_ = outSingleAntennaRFEH_ + outageFnc(h(1,:),Phi,g,xi,'DC combining')/MCruns;
        outDCComb_ = outDCComb_ + outageFnc(h,Phi,g,xi,'DC combining')/MCruns;
        outRFComb_ = outRFComb_ + outageFnc(h,Phi,g,xi,'RF combining')/MCruns;
    end
    
    % outage probability vs RF tx density
    outSingleAntennaRFEH(ii) = outSingleAntennaRFEH_;
    outDCComb(ii) = outDCComb_;
    outRFComb(ii) = outRFComb_;
end
 
%% Plot results 
fig = figure;
plotSettings(fig)

loglog(lambda,outSingleAntennaRFEH,'-s','Color','#0072BD','LineWidth',1.5); hold on
loglog(lambda,outDCComb,'-o','Color','#D95319','LineWidth',1.5)
loglog(lambda,outRFComb,'-^','Color','#EDB120','LineWidth',1.5)

% Plot annotations
annotation('arrow',[0.516713091922006 0.605849582172702],...
    [0.791494481236203 0.845474613686534],'LineWidth',1);
annotation('arrow',[0.515320334261838 0.557103064066852],...
    [0.341163355408389 0.428256070640176],'LineWidth',1);
annotation('line',[0.516713091922006 0.516713091922006],...
    [0.921737306843267 0.11037527593819],'LineWidth',1,'LineStyle','--');
annotation('textbox',[0.547353760445682 0.431671082796114 0.094707518483935 0.0596026478882129],...
    'String',{'99.95%'},'LineStyle','none');
annotation('textbox',[0.5974930362117 0.842267109286176 0.0835654575346573 0.059602647888213],...
    'String',{'62.5%'},'LineStyle','none');

hold off
grid on 
box on 
ylim([1e-5 1])

xlabel('Density of RF sources $[\mathrm{transmitters}/\mathrm{km}^2]$','FontSize',15,'Interpreter','latex')
ylabel('Outage probability','FontSize',15,'Interpreter','latex')
legend('single antenna','four antennas DC combining','four antennas RF combining','FontSize',12,'location','southwest','Interpreter','latex')