function [y_pl, stable_phases] = binary_stable_phase_identification(frac,ef)
    % function that generates the piecewise linear line between stable
    % phases and identifies what phases are stable (to plot afterwards)

    %x = T{:,"oxidant_fraction"};
    %y = T{:,"Ef_eV"};

    % Stable Phase Identification 
    
    residual = ef;
    nodes = [1,length(frac)]; % starting with nodes at the stable pure phases (labeled as array indexes)
    
    halt = 0;
    while halt == 0
        % loop over our new node generation untill there are no new nodes required
        % to bound our formation energies from below with piecewise liniarity     
        [residual, nodes, halt] = binary_node_identification(frac,residual,nodes);
    end
    %stable_phases = ismember(residual,0); 
    % used to calculate off of i the residual was 0 but floating point 
    % error got in the way, just using node positions, far simpler
    stable_phases = nodes;
    
    %[stable_phases,y_pl,y]
    
    % the piecewise linear plot is the diference between our residual and our unaltered data
    y_pl = ef - residual;
end