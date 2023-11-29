function harvestedEnergy = ambientEHFnc(x_b)
    % This function returns the available ambient energy at each a given
    % position x_b in the plane.
    % ARGUMENTS:
    % x_b               -> coordinates of the point [m]
    % RETURN VALUES:
    % harvestedEnergy   -> harvested energy at the given point [W]

    % Model of the available ambient energy (sum of Gaussian functions)
    mu1 = [-5 -5];
    sigma1 = [5 0; 0 5];

    mu2 = [5 -5];
    sigma2 = [3 0; 0 3];

    mu3 = [5 5];
    sigma3 = [2 0; 0 2];

    mu4 = [-5 5];
    sigma4 = [7 0; 0 7];

    mu5 = [0 0];
    sigma5 = [8 0; 0 8];
    
    peaks = 1e2*ones(5,1);
    MU = {mu1, mu2, mu3, mu4, mu5};
    SIGMA = {sigma1, sigma2, sigma3, sigma4, sigma5};
        
    % harvested energy
    harvestedEnergy = 0;
    for ii = 1:5
        harvestedEnergy = harvestedEnergy + peaks(ii)*mvnpdf(x_b,MU{ii},SIGMA{ii});
    end
end