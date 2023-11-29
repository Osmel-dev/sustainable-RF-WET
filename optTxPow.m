function txPow = optTxPow(H,Nt,K,p)
    % This function returns the optimal PB's transmission power.
    % ARGUMENTS:
    % H -> rank-1 channel matrix (semidefinite formulation)
    % Nt -> number of active RF chains (= antennas)
    % K -> number of deployed devices
    % p -> received power requirement at the devices [W]
    % RETURN VALUES:
    % txPow -> transmission power [W]

    %% Optimization problem (semidefinite formulation)
    cvx_begin quiet
        variable W(Nt,Nt) hermitian semidefinite 
        minimize( trace(W) )
        subject to
            % constr. 1
            for kk = 1:K
                real(trace(H(:,:,kk)*W)) >= p
            end
    cvx_end
    
    %% optimal value
    txPow = trace(W);
end

