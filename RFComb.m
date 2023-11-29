function pdc = RFComb(h,Phi,g)
    % This function computes the harvested energy for the RF combining 
    % receiver architecture. 
    % h             -> channel realization 
    % Phi           -> phase shifters configuration (RF combining)
    % g             -> RF-EH function
    % RETURN VALUES:
    % pdc        -> harvested energy

    %% Optimal phase shifter configuration
    [M,K] = size(h);
   
    % select the DFT precoder that maximizes the received power
    prf = 0;
    for mm = 2:M
        u = 1/sqrt(M)*exp(1i*Phi(:,mm)');
        
        prf_ = 0;
        for kk = 1:K
            prf_ = prf_ + abs(u*h(:,kk))^2;
        end

        if prf_ > prf
            prf = prf_;
        end
    end

    %% Harvested energy
    pdc = g(prf);
end

