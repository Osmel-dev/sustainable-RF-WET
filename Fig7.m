% This script can be used to reproduce Fig. 7 in the manuscript:
% O. M. Rosabal, O. L. A. López, H. Alves and M. Latva-aho, 
% "Sustainable RF Wireless Energy Transfer for Massive IoT: enablers and challenges," 
% in IEEE Access, doi: 10.1109/ACCESS.2023.3337214.
clear; clc;

%% Simulation settings
p = [1e-4 1e-3];        % received power requirement at the devices [W]
K = [4 8];              % number of devices
radius = 10;            % radius of the coverage area [m]
kappa = 10;             % Rician LoS factor [linear]
Nt = 2:16;              % number of active RF chains (= antennas)
MCruns = 1e4;           % Monte Carlo iterations

%% Monte Carlo simulation

% memory pre-allocation
powConsump = zeros(numel(p),numel(K),numel(Nt));

for pp = 1:numel(p)
    for kk = 1:numel(K)
        for nt = 1:numel(Nt)
            powConsump_ = 0;
            for mc = 1:MCruns
                
                % Channel model (ULA)
                d = radius*sqrt(rand(K(kk),1));
                theta = 2*pi*rand(K(kk),1);
                
                beta = 10^(-1.6)*max(1,d).^(-2.7);
            
                h_los = zeros(Nt(nt),K(kk));        % LoS component
                h_nlos = zeros(Nt(nt),K(kk));       % NLoS component
                for kk1 = 1:K(kk)
                    phi = -(0:(Nt(nt)-1))'*pi*sin(theta(kk1));
                    h_los(:,kk1) = sqrt(beta(kk1))*sqrt(kappa/(1+kappa))*exp(1i*phi);
                    h_nlos(:,kk1) = sqrt(beta(kk1))*sqrt(1/(2*(1+kappa)))*(randn(Nt(nt),1)+1i*randn(Nt(nt),1));
                end
                h = h_los + h_nlos;
        
                H = zeros(Nt(nt),Nt(nt),K(kk));
                for kk1 = 1:K(kk)
                    H(:,:,kk1) = h(:,kk1)*h(:,kk1)';
                end
                
                %% Optimization problem 
                txPow = optTxPow(H,Nt(nt),K(kk),p(pp));
                
                powConsump_ = powConsump_ + (txPow/.35 + .5*Nt(nt))/MCruns;
            end    
        
            powConsump(pp,kk,nt) = powConsump_;
        end
    end
end

%% Plot results
% 
p1 = semilogy(Nt,powConsump(2,1,:),'-s','Color','#0072BD','LineWidth',1.5); hold on
[val,idx] = min(powConsump(2,1,:));
loglog(Nt(idx),val,'p','Color','k','MarkerSize',12,'MarkerFaceColor','k');
%
p2 = semilogy(Nt,powConsump(2,2,:),'-o','Color','#D95319','LineWidth',1.5);
[val,idx] = min(powConsump(2,2,:));
loglog(Nt(idx),val,'p','Color','k','MarkerSize',12,'MarkerFaceColor','k');
%
semilogy(Nt,powConsump(1,1,:),'-s','Color','#0072BD','LineWidth',1.5) 
[val,idx] = min(powConsump(1,1,:));
loglog(Nt(idx),val,'p','Color','k','MarkerSize',12,'MarkerFaceColor','k');
%
semilogy(Nt,powConsump(1,2,:),'-o','Color','#D95319','LineWidth',1.5); 
[val,idx] = min(powConsump(1,2,:));
loglog(Nt(idx),val,'p','Color','k','MarkerSize',12,'MarkerFaceColor','k');
%
p3 = loglog(NaN,NaN,'p','Color','k','MarkerSize',12,'MarkerFaceColor','k');

% Annotations
annotation('ellipse',[0.203489035087719 0.602881944444444 0.0226732456140352 0.1190625],'LineWidth',1);
annotation('textbox',[0.176030701754386 0.519861111741927 0.0925269896522486 0.0643819438136286],...
    'String',{'1 mW'},'LineStyle','none','Interpreter','latex','FontSize',12);
annotation('ellipse',[0.373379385964913 0.329479166666666 0.0184956140350871 0.108038194444445],'LineWidth',1);
annotation('textbox',[0.336173245614035 0.246458333964149 0.109856479906163 0.0643819438136286],...
    'String',{'0.1 mW'},'LineStyle','none','Interpreter','latex','FontSize',12);

hold off
grid on
box on
ylim([1 100])
xlabel('Number of RF chains','FontSize',15,'Interpreter','latex')
ylabel('Power consumption (W)','FontSize',15,'Interpreter','latex')
legend([p1 p2 p3], '4 IoT devices','8 IoT devices','optimum value', 'FontSize',14,'Interpreter','latex')