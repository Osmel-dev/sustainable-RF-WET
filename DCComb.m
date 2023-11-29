function pdc = DCComb(h,g)
    % This function computes the harvested energy for the DC combining
    % receiver architecture.
    % ARGUMENTS:
    % h                 -> channel realization
    % g                 -> RF-EH transfer function
    % RETURN VALUES:
    % pdc               -> harvested energy 

    M = size(h,1);

    pdc = 0;
    for mm = 1:M
        pdc = pdc + g(norm(h(mm,:))^2);
    end
end