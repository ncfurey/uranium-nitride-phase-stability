function [spid, mspid, u, v, k] = define_stable_phases(T,composition,deltaE_metastable,show_change_of_basis)
% function that returns the id's of stable phases (spid) and the id's of
% metastable phases (mspid), dependant of definition of metastable, where
% deltaE_metastable is the height above the convex hull to define as
% metastable.

% ORIGINALLY WRITTEN FOR UNO HARDCODED, REWRITTEN TO WORK GENERALLY
   
x1 = T{:,2};
x2 = T{:,3};
x3 = T{:,4};
x4 = T{:,"Ef_eV"};
   
% p and q are the vectors that span the plane (x+y+z=1) that all the points
% in x1,x2,x3 (3d) space lie on. If we change variables to p & q then we
% can express this as a 3d convex hull problem rather than 4d.

%        O       the point (.) is the UNO point where all fractions are a third
%       / \      p runs paralell to N->U, from (.) , and q runs from (.)->O
%      /   \
%     /  .  \ 
%    /       \
%   /_________\
%  N           U
    
% if you want to see a proper plot, change the "show change of basis"
% variable to 1
    
if show_change_of_basis == 1
    scatter3(x1,x2,x3,10,x4,"filled")
    hold on 
    [X,Y] = meshgrid(0:0.1:1, 0:0.1:1);
    Z = 1 - X - Y;
    s = surf(X,Y,Z);
    s.FaceAlpha = 0.1;
    %plot3([1/3,1],[1/3,1],[1/3,1],'-r')
    plot3([0,1/sqrt(3)],[0,1/sqrt(3)],[0,1/sqrt(3)],'r')
    plot3([1,0],[0,1],[0,0],'g')
    plot3([0,1/2],[0,1/2],[1,0],'b')
    %plot3([0,1/sqrt(3)],[0,1/sqrt(3)],[0,1/sqrt(3)],'--g',LineWidth=2)
    view([495.000 35.000])
    xlabel(composition(1))
    ylabel(composition(2))
    zlabel(composition(3))
    xlim([0 1])
    ylim([0 1])
    zlim([0 1])
    legend({'points spanning the plane','plane','p','q','r'})
    hold off
    clear X Y Z s
end
    
p = [-1/sqrt(2), 1/sqrt(2), 0];
q = [-1/sqrt(6), -1/sqrt(6), 2/sqrt(6)];
u = zeros(length(x1),1);
v = zeros(length(x1),1);
x_frac = [x1,x2,x3];
for i = 1:length(x1)
u(i) = dot(p,x_frac(i,:));
v(i) = dot(q,x_frac(i,:));
end
    
% defining convex hull of stable phases (some false ids to be removed still)
k = convhull(u,v,x4);
 
% if a point is less than 0.1 eV above the lower hull, it is metastable
% some literature says 80 meV but staying at 0.1 for now
  
% I will move each point, in turn, down by the metastable phase def and if
% there is a change to the convex hull, then its metastable 
    
k_numb_nodes = height(k);
mspid = zeros(height(T),1);
kids = T{unique(k(:)),'id'};
for i = 1:height(T)
    pertubated_x4 = x4;
    pertubated_x4(i) = pertubated_x4(i) - deltaE_metastable;
    kms = convhull(u,v,pertubated_x4);
    kmsids = T{unique(kms(:)),'id'};
    if height(kms) ~= k_numb_nodes
        mspid(i) = T{i,'id'};
    elseif kmsids ~= kids
        mspid(i) = T{i,'id'};
    end
end
mspid = nonzeros(mspid);
disp([num2str(k_numb_nodes),' convex hull nodes identified'])
disp([num2str(length(mspid)),' metastable phases found on first pass'])
 
% need to systematically remove planes from k
planes_to_remove = zeros(height(k),1);
kx4 = x4(k);
    
% identifying all stable phases on the edges of the triangle

% the element1-element2 edge
T_1 = T;
T_1(contains(T.Properties.RowNames, composition(3)), :) = [];
T_1 = sortrows(T_1,composition(2),"ascend");
[~, bsp1] = binary_stable_phase_identification(T_1{:,3},T_1{:,"Ef_eV"});
trm1 = zeros(height(T_1),1);
trm1(bsp1) = 1;
T_rm1 = T_1;
T_rm1(logical(trm1),:) = []; % now T_1 has all the stable phses removed, now a list of items to remove from our k matrix

% element2-element3
T_2 = T;
T_2(contains(T.Properties.RowNames, composition(1)), :) = [];
T_2 = sortrows(T_2,composition(3),"ascend");
[~, bsp2] = binary_stable_phase_identification(T_2{:,4},T_2{:,"Ef_eV"});
trm2 = zeros(height(T_2),1);
trm2(bsp2) = 1;
T_rm2 = T_2;
T_rm2(logical(trm2),:) = []; % now T_2 has all the stable phses removed, now a list of items to remove from our k matrix

% element1-element3
T_3 = T;
T_3(contains(T.Properties.RowNames, composition(2)), :) = [];
T_3 = sortrows(T_3,composition(3),"ascend");
[~, bsp3] = binary_stable_phase_identification(T_3{:,4},T_3{:,"Ef_eV"});
trm3 = zeros(height(T_3),1);
trm3(bsp3) = 1;
T_rm3 = T_3;
T_rm3(logical(trm3),:) = []; % now T_3 has all the stable phses removed, now a list of items to remove from our k matrix

bnsp = vertcat(T_rm1{:,'id'},T_rm2{:,'id'},T_rm3{:,'id'}); %id's of all binary phases that arent stable
bsp12 = T_1{bsp1,"id"};
bsp23 = T_2{bsp2,"id"};
bsp13 = T_3{bsp3,"id"};

for i = 1:height(k)
    % remove top layer(s)
    if max(kx4(i,:)) > 0
        planes_to_remove(i) = 1;
    elseif sum(kx4(i,:)) == 0
        planes_to_remove(i) = 1;
    end
    % remove all binary non-stable phases
    if min(abs(k(i,1)-bnsp)) == 0 || min(abs(k(i,2)-bnsp)) == 0 || min(abs(k(i,3)-bnsp)) == 0
        planes_to_remove(i) = 1;
    % if a plane only connects to binary stable pases of the samy type then
    % its not in the lower convex hull.
    elseif min(abs(k(i,1)-bsp12)) == 0 && min(abs(k(i,2)-bsp12)) == 0 && min(abs(k(i,3)-bsp12)) == 0
        planes_to_remove(i) = 1;
    elseif min(abs(k(i,1)-bsp23)) == 0 && min(abs(k(i,2)-bsp23)) == 0 && min(abs(k(i,3)-bsp23)) == 0
        planes_to_remove(i) = 1;
    elseif min(abs(k(i,1)-bsp13)) == 0 && min(abs(k(i,2)-bsp13)) == 0 && min(abs(k(i,3)-bsp13)) == 0
    planes_to_remove(i) = 1;
    end
end
disp([num2str(sum(planes_to_remove)),' planes removed'])
    
k(logical(planes_to_remove),:) = [];
spid = T{unique(k(:)),'id'};


rm_msp_id = zeros(size(mspid));
for i = 1:length(mspid)
    if min(abs(mspid(i) - spid)) == 0
        rm_msp_id(i) = 1;
    end
end
mspid(logical(rm_msp_id)) = [];

disp([num2str(length(spid)),' stable-phases and ',num2str(length(mspid)),' metastable-phases identified after trimming to lower covex hull'])

