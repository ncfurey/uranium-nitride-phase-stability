function frac = define_composition_axis(formula,default_comp)
    % - - - - - define_composition_axis - - - - - - - ORIGINALLY HARDCODED FOR TERNARY UxNyOz
    % we now have formulae of the form - UxIyJz or Ux(IyJz)n where I & J are
    % our oxidants, we can now have groups in our solid (in brackets)
    % with their own stoichiometry, to develop fractions we will need to regen
    % a machine readable version of the formula with UxI(y*n)J(z*n) parallel to
    % the formulae array to read teh fracional composition fractions.
    
    formula = char(formula);
    elements = char(default_comp);
    stoich = zeros(length(default_comp),1);
    frac = zeros(length(default_comp),1);

    for i = 1:length(default_comp)
        stoich(i) = get_stoichiometry(formula,elements(i));
    end
    
    for i = 1:length(default_comp)
        frac(i) = stoich(i) / (sum(stoich(:)));
    end
end