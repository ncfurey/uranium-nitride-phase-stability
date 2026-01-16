function clean = read_suplementary_data(filename,composition)
data = readtable(['input\',filename]);
data = unique([data(:,"formula"),data(:,"Ef")]);       % triming down unnescesary cols cols and removing dupe rows
clean = table();
j = 1;
% this will only take values that are within the phase diagram as defined
% by the user-provided composition
for i = 1:height(data)
    str = regexprep(char(data{i,"formula"}), '\d', ''); % removing all non-alphabetic characters from the string 
    str = sort(str); % sorting alphabetically to remove all abc/acb permutations of the formula
    if strcmp(str,sort(composition)) | ...
       strcmp(str,sort([composition(1),composition(2)])) | ...
       strcmp(str,sort([composition(1),composition(3)])) | ...
       strcmp(str,sort([composition(2),composition(3)])) 
        clean(j,:) = data(i,:);
        j = j+1;
    end
end
end