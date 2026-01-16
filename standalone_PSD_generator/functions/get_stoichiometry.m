function stoich = get_stoichiometry(formula,element)
    % searches for all consecutive digits after a given starting point and
    % returns the number ie reads U1234NO as 1234. if told to look for 'U'
    % in the character array.
    element_idx = strfind(formula,element);
    formula = [formula(element_idx+1:end),'|'];     % only considering the relevent part of the formula and adding a stopper to the end "|" so we never have an empty string
    i = 1;
    stoich = 0;
    %disp(['is ',formula(i),' a digit?: ',num2str(~isnan(str2double(formula(i))))])
    if isnan(str2double(formula(i))) && ~isempty(element_idx) % logical if the i-th char in the string is NOT a digit 
        %disp('No subsequent digits')
        stoich = 1;            % if no number follows our element then stoich is 1 (AB2 = A1B2)
    elseif ~isnan(str2double(formula(i)))
        %disp('∃ subsequent digits')
        while ~isnan(str2double(formula(i)))
            stoich = stoich + 10^(1-i)*str2double(formula(i)); % appending new digit 1 dp lower than last
            i = i+1;    % incrementing counter
        end
        stoich = stoich*10^(i-2); % multiplying up by 10 ^ (number of digits appended)
        %disp(stoich)
    end
    % as we can have formulae of the form Ux(IyJz)n we need to check for
    % brackets and retun stoich of y*n and z*n
    
    open_bracket = strfind(formula,'(');
    close_bracket = strfind(formula,')');
    if isempty(open_bracket) && ~isempty(close_bracket) % as we remove  char before our element if open bracket is missing then we are in the brackets
        stoich = stoich * str2double(formula(close_bracket+1:end-1)); % only works with assumption that the last item is our brackets and we have only 1 set of brackets
    end
end