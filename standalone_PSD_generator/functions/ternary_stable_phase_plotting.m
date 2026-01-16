function ternary_stable_phase_plotting(T,R,tR,tT,view3d,uv_axis,phase_display)

    % T = table containing all data from the datapreprocessing
    % R = structure containing all teh data from the stable phase identification
    % if preceded by "t" its the same but for the UNO training data
    % view3d = 0 or 1 if 0 we look at ot from top down by default
    % uv_axis = 0 or 1 : if 0 we dont display the u-v external axis (transform vectors)
    % phase_display = 0 => no formulae of stable phases displayed (in plot)
    %                   => formulae for stable phases given (in plot)
    %                   => formulae for stable and metastable phases given (in plot)

    train_u = tR.u;
    train_v = tR.v;
    train_x4 = tT{:,"Ef_eV"};
    u = R.u;
    v = R.v;
    
    
    p = [-1/sqrt(2), 1/sqrt(2), 0];
    q = [-1/sqrt(6), -1/sqrt(6), 2/sqrt(6)];
    
    %x1 = T{:,"N"};
    %x2 = T{:,"U"};
    %x3 = T{:,"O"};
    x4 = T{:,"Ef_eV"};
    k = R.k;

    f = figure;
    f.Position = [100, 100, 1200, 600];
    
    % ML identified points
    scatter3(u, v, x4, 15, x4, "filled")
    %T = [T, table(u,VariableNames={'u'}), table(v,VariableNames={'v'})]   ! ! ! !DOESNT WORK ! ! !
    %scatter3(T, 'u', 'v', 'Ef_eV', 15, 'Ef_ev', "filled") %plotting from a tabe lets us see rownames (formulae) when hovering cursour over a point
    hold on
    
    % training data
    scatter3(train_u,train_v,train_x4, 'or')

    % convex hull
    ts = trisurf(k, u, v, x4);
    ts.FaceAlpha = 0.1;
    ts.FaceColor = '#04471C';

    floor_of_plot = min(x4);
    
    if phase_display == 1
        for i = 1:length(R.spid)
            text(u(R.spid(i)), v(R.spid(i)), x4(R.spid(i)), T.Properties.RowNames{R.spid(i)},"Color",'#04471C')
        end
        text(p(2),q(3),floor_of_plot,'Stable Phases',"Color",'#04471C','HorizontalAlignment','right')
    elseif phase_display == 2
        for i = 1:length(R.spid)
            text(u(R.spid(i)), v(R.spid(i)), x4(R.spid(i)), T.Properties.RowNames{R.spid(i)},"Color",'#04471C')
        end
        text(p(2),q(3),floor_of_plot,'Stable Phases',"Color",'#04471C','HorizontalAlignment','right')
        for i = 1:length(R.mspid)
            text(u(R.mspid(i)), v(R.mspid(i)), x4(R.mspid(i)), T.Properties.RowNames{R.mspid(i)}, 'Color','magenta')
        end
        text(p(2),q(3)-0.1,floor_of_plot,'Metastable Phases',"Color",'magenta','HorizontalAlignment','right')
    elseif phase_display == 3
        for i = 1:length(R.spid)
            text(u(:), v(:), x4(:), char(T.Properties.RowNames{:}),"Color",'b','FontWeight','normal','FontSize',8)
        end
    end
    

    % - - - - - axis, labels, chevrons, and grid generation - - - - - 
    marker_spacing = 0.1;
    ternary_axis_generation(p,q,floor_of_plot,marker_spacing,0.1)
    
    % colourbar
    cd = colorbar();
    cd.Label.String = 'E_f [eV atom^-^1]';

    xlabel('u [arb. units]')
    ylabel('v [arb units]')
    zlabel('E_f [eV]')
    title([R.learningtype,': Ternary Phase Stability Plot'])
    %ylim([q(1)-3*marker_spacing q(3)+3*marker_spacing])   % setting limits with axis() 
    %axis equal 
    
    axis([ min(p)-3*marker_spacing max(p)+3*marker_spacing min(q)-3*marker_spacing max(q)+3*marker_spacing floor_of_plot max(x4) ])
    
    % checking user-given display settings
    if logical(uv_axis)
        axis off
        axis([min(p)-1*marker_spacing    max(p)+1*marker_spacing ...
              min(q)-1.5*marker_spacing  max(q)+1.5*marker_spacing ...
              floor_of_plot              max(x4) ])
    else
        axis([min(p)-3*marker_spacing max(p)+3*marker_spacing ...
              min(q)-3*marker_spacing max(q)+3*marker_spacing ...
              floor_of_plot           max(x4) ])
    end
    grid off
    if ~logical(view3d)
        view([360.00 90.00])
    end
    legend({'ML identified phases','UNO training data','Lower convex hull'})
    
    hold off
    
    disp(['Stable Phases identified via ',R.learningtype,' learning:'])
    disp(T(R.spid,"Ef_eV"))
    disp(['Metastable Phases identified via ',R.learningtype,' learning:'])
    disp(T(R.mspid,"Ef_eV"))
    
end