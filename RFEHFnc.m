function inRFEnergy = RFEHFnc(x_b,x_s,Pt)
    % This function returns the available RF energy at a given device.
    % ARGUMENTS:
    % x_b           -> matrix of PBs' positions (num. PBs x 2) [m]
    % x_s           -> matrix of devices positions (num. devices x 2) [m]
    % Pt            -> PBs' maximum transmission power [W]
    % RETURN VALUES: 
    % inRFEnergy    -> harvested energy at the devices [W]

    % wavelength of the energy-carrying signal
    lambda = physconst('lightspeed')/1e9; 

    % computation of the harvested energy
    inRFEnergy = zeros(size(x_s,1), 1);
    for ss = 1:size(x_s,1)
        dist = sqrt((x_s(ss,1) - x_b(:,1)).^2 + (x_s(ss,2) - x_b(:,2)).^2);
        inRFEnergy(ss) = sum(min(ambientEnergy(x_b),Pt).*min((lambda./(4*pi*dist)).^2,1));
    end
end