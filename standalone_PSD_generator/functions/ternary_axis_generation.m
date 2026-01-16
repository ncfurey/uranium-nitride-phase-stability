function ternary_axis_generation(p,q,floor_of_plot,marker_spacing,vertex_spacing)

    % our pure phases will be always atthe points we use to define our variable change
    vertexs = [p(end-2), q(end-2);    % N
               p(end-1), q(end-1);    % U
               p(end)  , q(end)  ;    % O
               p(end-2), q(end-2)];   % N again to aid cyclic permutation notation
    
    plot3([vertexs(1:2,1)],[vertexs(1:2,2)],[floor_of_plot,floor_of_plot],'k', LineWidth=2)
    plot3([vertexs(2:3,1)],[vertexs(2:3,2)],[floor_of_plot,floor_of_plot],'k', LineWidth=2)
    plot3([vertexs(3:4,1)],[vertexs(3:4,2)],[floor_of_plot,floor_of_plot],'k', LineWidth=2)
    
    pmarkers = [linspace(vertexs(1,1),vertexs(2,1),6);  % NU
                linspace(vertexs(2,1),vertexs(3,1),6);  % UO
                linspace(vertexs(3,1),vertexs(4,1),6)]; % UO
    qmarkers = [linspace(vertexs(2,2),vertexs(2,2),6);  % NU
                linspace(vertexs(2,2),vertexs(3,2),6);  % UO
                linspace(vertexs(3,2),vertexs(4,2),6)]; % UO;
    markertext = {'0','0.2','0.4','0.6','0.8','1';
                  ' ','0.8','0.6','0.4','0.2','0';
                  ' ','0.2','0.4','0.6','0.8','1'};
    plot3(pmarkers(1,:), qmarkers(1,:), ones(6,1)*floor_of_plot, '+k', 'MarkerSize',15)
    plot3(pmarkers(2:3,:), qmarkers(2:3,:), ones(6,1)*floor_of_plot, 'xk', 'MarkerSize',15) % if I want different NU markers uncomment and change index in next line from 1:2 to 2:2
    
    % axis marker labeling
    %marker_spacing = 0.1;
    pmarker_labels(:,:) = [pmarkers(1,:)                         ; %
                           pmarkers(2,:)+marker_spacing*sin(pi/6);
                           pmarkers(3,:)-marker_spacing*sin(pi/6)];
    qmarker_labels(:,:) = [qmarkers(1,:)-marker_spacing          ; %
                           qmarkers(2,:)+marker_spacing*cos(pi/6);
                           qmarkers(3,:)+marker_spacing*cos(pi/6)];
    text(pmarker_labels(:), qmarker_labels(:), ones(18,1)*floor_of_plot, markertext,'FontSize',10,'HorizontalAlignment','center')
    
    % axis labeling
    axis_labels = [mean(vertexs(1:2,1)), mean(vertexs(1:2,2)) - 2*marker_spacing;
                   mean(vertexs(2:3,1))+2*marker_spacing*sin(pi/6), mean(vertexs(2:3,2))+2*marker_spacing*cos(pi/6); 
                   mean(vertexs(3:4,1))-2*marker_spacing*sin(pi/6), mean(vertexs(3:4,2))+2*marker_spacing*cos(pi/6)];
    text(axis_labels(1,1),axis_labels(1,2),floor_of_plot,'U_xN_x_-_1', 'FontSize',14, 'HorizontalAlignment','center')
    text(axis_labels(2,1),axis_labels(2,2),floor_of_plot,'U_yO_y_-_1', 'FontSize',14, 'HorizontalAlignment','left')
    text(axis_labels(3,1),axis_labels(3,2),floor_of_plot,'N_zO_z_-_1', 'FontSize',14, 'HorizontalAlignment','right')
    
    % vertex labels
    %vertex_spacing = 0.05; % adding some room between vertexes and their labels
    vertex_labels = [vertexs(1,1)-vertex_spacing*cos(pi/6),vertexs(1,2)-vertex_spacing*sin(pi/6), floor_of_plot;
                     vertexs(2,1)+vertex_spacing*cos(pi/6),vertexs(2,2)-vertex_spacing*sin(pi/6), floor_of_plot;
                     vertexs(3,1)                         ,vertexs(3,2)+vertex_spacing          , floor_of_plot];
    text(vertex_labels(1,1),vertex_labels(1,2),vertex_labels(1,3), 'N','FontSize',14,'HorizontalAlignment','center')
    text(vertex_labels(2,1),vertex_labels(2,2),vertex_labels(2,3), 'U','FontSize',14,'HorizontalAlignment','center')
    text(vertex_labels(3,1),vertex_labels(3,2),vertex_labels(3,3), 'O','FontSize',14,'HorizontalAlignment','center')
    
    % gridlines
    % go from n in 1 marker array to end -n in the subsequent marker array
    
    gridpoints = [pmarkers(1,1+1), qmarkers(1,1+1);     % positive diagonals
                  pmarkers(2,6-1), qmarkers(2,6-1);
                  pmarkers(2,6-2), qmarkers(2,6-2);
                  pmarkers(1,1+2), qmarkers(1,1+2);
                  pmarkers(1,1+3), qmarkers(1,1+3);
                  pmarkers(2,6-3), qmarkers(2,6-3);
                  pmarkers(2,6-4), qmarkers(2,6-4);
                  pmarkers(1,1+4), qmarkers(1,1+4);     % negative diagonals
                  pmarkers(3,1+1), qmarkers(3,1+1);
                  pmarkers(3,1+2), qmarkers(3,1+2);
                  pmarkers(1,6-2), qmarkers(1,6-2);
                  pmarkers(1,6-3), qmarkers(1,6-3);
                  pmarkers(3,1+3), qmarkers(3,1+3);
                  pmarkers(3,1+4), qmarkers(3,1+4);
                  pmarkers(1,6-4), qmarkers(1,6-4);     % horizontal, need to round the corner first
                  pmarkers(1,1+0), qmarkers(1,1+0);     % going via the UNO corner of the plot
                  pmarkers(3,6-1), qmarkers(3,6-1);
                  pmarkers(2,1+1), qmarkers(2,1+1);
                  pmarkers(2,1+2), qmarkers(2,1+2);
                  pmarkers(3,6-2), qmarkers(3,6-2);
                  pmarkers(3,6-3), qmarkers(3,6-3);
                  pmarkers(2,1+3), qmarkers(2,1+3);
                  pmarkers(2,1+4), qmarkers(2,1+4);
                  pmarkers(3,6-4), qmarkers(3,6-4)];
    
    plot3(gridpoints(:,1), gridpoints(:,2), ones(length(gridpoints(:,1)),1)*floor_of_plot, '--','Color',[0.8 0.8 0.8 0.2])
end