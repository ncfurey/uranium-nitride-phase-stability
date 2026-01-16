function [residual, nodes, halt_condition] = binary_node_identification(x,y,nodes)
    % this function is used iterativly. When given the dataset of Ef wrt to
    % phase, it will identify the global minimum and partition it into 2 PL
    % segments. Further iterations will find points below the residual and 
    % generate a new node. This is repeted untill there are no phases below
    % our PL curve.
    % original residual is wrt PL between pure phases.

    % if points below our current line we need an aditional node to
    % describe this stable phase 
    
    [~, node] = min(y);
    %disp(x(node))
    if ismember(node, nodes)
        halt_condition = 1;
        residual = y;
        return;
    end
    nodes = [nodes,node];
    nodes = sort(nodes);

    [~, node_idx] = min(abs(nodes - node));
    nodeLHS = nodes(node_idx-1); % left neighbour
    nodeRHS = nodes(node_idx+1); % right neighbour

    % find line connecting neighboring nodes to this new one
    % generating peicwise linearity with y = m x - m*xNode + yNode. Where: m = (yNeibour - yNode) / (xNeibour - xNode) 
    % xI and yI are node coordinates in Ef eV/atom and nitrogen fraction.
    y_plLHS = ((y(nodeLHS) - y(node)) / (x(nodeLHS) - x(node))).*x ...   % peicewise linearity new node and LHS node neighbour
             -((y(nodeLHS) - y(node)) / (x(nodeLHS) - x(node)))*x(node) + y(node);
    y_plRHS = ((y(nodeRHS) - y(node)) / (x(nodeRHS) - x(node))).*x ...   % peicewise linearity new node and RHS node neighbour
             -((y(nodeRHS) - y(node)) / (x(nodeRHS) - x(node)))*x(node) + y(node);
    y_pl = vertcat(y_plLHS(1:node),y_plRHS(node+1:end));
    %( (y(nodeLHS) - y(node) ) / ( x(nodeLHS) - x(node) ) )
    %((y(nodeRHS) - y(node)) / (x(nodeRHS) - x(node)))

    residual = y;
    residual(nodeLHS:nodeRHS) = residual(nodeLHS:nodeRHS) - y_pl((nodeLHS:nodeRHS));
    %disp(['Stable Nodes [oxidant-fraction]:    ',num2str(x(nodes).')])
    
    % checking if another iteration will be required.
    newnode_val = min(residual);
    if newnode_val >= 0
        halt_condition = 1;
        %disp(['No new nodes to find, ', num2str(length(nodes)),' stable phases found'])
        nodes = unique(nodes); % otehrwise numerical error can cause double counting 
    else
        halt_condition = 0;
    end
    
end