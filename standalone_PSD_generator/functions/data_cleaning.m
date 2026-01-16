function clean = data_cleaning(filename,composition)

data = readtable(['input\',filename]);
data = unique([data(:,"formula"),data(:,"Ef")]);       % triming down unnescesary cols cols and removing dupe rows
% the unique function doesnt always work due to floating point error so we
% define a new unique function based off of the "formula" value
rm_rows = zeros(height(data),1);
for i = 2:height(data)
    if strcmp(data(i,"formula"),data(i-1,"formula"))
        rm_rows(i) = 1;
    end
end
data(logical(rm_rows),:) = [];

pure_entry1 = table(1,0,0,0,VariableNames={composition(1),composition(2),composition(3),'Ef_eV'}, RowNames={composition(1)});
pure_entry2 = table(0,1,0,0,VariableNames={composition(1),composition(2),composition(3),'Ef_eV'}, RowNames={composition(2)});
pure_entry3 = table(0,0,1,0,VariableNames={composition(1),composition(2),composition(3),'Ef_eV'}, RowNames={composition(3)});


fractional_axis = zeros(height(data),3);
for i = 1:height(data)
    fractional_axis(i,:) = define_composition_axis(data{i,"formula"},composition);
end
clean = table(fractional_axis(:,1),fractional_axis(:,2),fractional_axis(:,3),data{:,"Ef"},...
              VariableNames={composition(1),composition(2),composition(3),'Ef_eV'},...
              RowNames=data{:,"formula"});
clean= vertcat(clean,pure_entry1,pure_entry2,pure_entry3);
clean = [table((1:1:height(clean)).',VariableNames={'id'}) clean];

end