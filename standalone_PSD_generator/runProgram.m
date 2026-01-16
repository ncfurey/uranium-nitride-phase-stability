% Wrapper Script for the Phase Diagram generator 

readcsvUC = true;  % if se to alse you justnned to change the values in this wrapper script 

% = = = = = USER DEFINED VARIABLES = = = = = 
userCom.composition = 'UNH';
userCom.filename = 'data_ternaryUNH-RF.csv';
userCom.num_elements = 3;
userCom.non_CH_data = 'targets_extra-cols.csv'; %points that will not impact the convex hull but will appear on the plot (ie data model may have been trained on)
userCom.non_CH_data_label = 'OQMD training data';
userCom.plotTitle = 'asdf';
userCom.show_change_of_basis = 1;
% = = = = = = = = = = = = = = = = = = = = = =

addpath functions\
tic
% cleaning data
clean = data_cleaning(userCom.filename,char(userCom.composition));

filename = userCom.non_CH_data;

% reading suplimentary data
if ~isnumeric(userCom.non_CH_data)
    non_CH_data = read_suplementary_data(userCom.non_CH_data,userCom.composition);
end
%%
[stable_pahse_ids, metastable_phase_ids, u, v, k] = define_stable_phases(clean,userCom.composition,0.1,userCom.show_change_of_basis);
results.spid = stable_pahse_ids;
results.mspid = metastable_phase_ids;
results.u = u;
results.v = v;
results.k = k;






toc