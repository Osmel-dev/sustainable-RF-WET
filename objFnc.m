function fObj = objFnc(x_s,x_b,Pt)
    % This function returns the harvested RF energy at a given device
    % (objective function GA optimization).
    % ARGUMENTS:
    % x_b           -> matrix of PBs' positions (num. PBs x 2) [m]
    % x_s           -> matrix of devices positions (num. devices x 2) [m]
    % Pt            -> PBs' maximum transmission power [W]
    % RETURN VALUES: 
    % inRFEnergy    -> harvested energy at the devices [W]

    B = numel(x_b);
    x_b = reshape(x_b, [B/2 2]);

    inRFEnergy = RFEHFnc(x_b,x_s,Pt);
    fObj = - min(inRFEnergy);
end