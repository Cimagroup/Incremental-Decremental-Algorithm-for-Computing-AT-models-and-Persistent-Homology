function viewhomology(points,dimension,boundary,H,g)
%DRAW_COMPLEX Summary of this function goes here
%   Complex cubic and homology are plotted

    % Variables used by patch are initialized
    % list_vertex is list of vertex coordinates
    list_vertex = zeros( sum( dimension==0 ), 3 );
    % vertex is list of vertex indexes
    vertex = zeros( sum( dimension==0 ) , 1);
    % list_face is list of face for patch
    list_face = zeros( sum( dimension==2 ), 4 );
    % num_vertex is number of vertexes added
    num_vertex = 0;
    % num_face is number of faces added
    num_face = 0;

    % 'cla' is used for clearing axes
    cla;
    hold on;
    axis auto;
    grid on;    
    view(3);
    daspect('auto');
    rotate3d on;

    % Cells of dimension 2 (face) are processed
    for i = find( dimension==2 )
        % Variables used in construction of face are initialized
        % list of face points is stored in cell0
        cell0 = zeros( 4, 1 );
        num_cell0 = 0;
        % list ordered of face points is stored in face
        face = zeros( 4, 1 );
        n_vertex_face = 0;
        % Face is constructed
        % k is boundary of boundary of cell of dimension 2 (list of vertexs
        % of a face of the cube)
        for j = boundary((boundary(:,i)>0),i)'
            for k = boundary((boundary(:,j)>0),j)'
                if isempty( find( cell0==k, 1 ) )
                    num_cell0 = num_cell0 + 1;
                    cell0(num_cell0) = k;
                    % k is searched in list of vertex indexes
                    pos_vertex = find( vertex==k, 1 );
                    n_vertex_face = n_vertex_face + 1;
                    % order_face controls order of painting
                    if n_vertex_face < 3
                        order_face = n_vertex_face;
                    elseif n_vertex_face == 3
                        order_face = 4;
                    else
                        order_face = 3;
                    end
                    % If vertex exists in list of vertexs then it isn't
                    % added to list of vertexs
                    if pos_vertex > 0
                        % Vertex index is added to list of face points
                        face(order_face) = pos_vertex;
                    else
                        num_vertex = num_vertex + 1;
                        list_vertex(num_vertex,:) = points(:,k)';
                        % Point 'k' is added to list of vertex indexes
                        vertex(num_vertex) = k;
                        % Vertex index is added to list of face points
                        face(order_face) = num_vertex;
                    end
                end
            end
        end
        % Face constructed is added to list_face
        num_face = num_face + 1;
        list_face(num_face,:) = face;
    end
    
    % Variables list_vertex and list_face are compressed
    list_vertex=list_vertex(1:num_vertex,:);
    list_face=list_face(1:num_face,:);
    
    % Variables list_vertex and list_face (complex cubic constructed) are
    % plotted
    p(1) = patch('Vertices',list_vertex,'Faces',list_face,'FaceAlpha',0.2,'FaceColor','red');
    hold on;

    % List of cell indexes added to homology is stored in homology
    homology=find(H==1);
    % Cells of homology are processed
    indexplot0 = 1;
    nhc0=intersect(homology,find(dimension==0));
    for i=nhc0
        % if dimension of cell is 0 then cell is plotted as dot
        indexplot0 = indexplot0 + 1;
        p(indexplot0) = plot3(points(1,i),points(2,i),points(3,i),'ko','markerfacecolor','k');
        hold on;
    end
    indexplot1 = indexplot0;
    nhc1=intersect(homology,find(dimension==1));
    for i=nhc1
        % if dimension of cell is 1 then cell is plotted as line
        line_homology=points(:,boundary(1:2,i)')';
        indexplot1 = indexplot1 + 1;
        p(indexplot1) = plot3(line_homology(:,1),line_homology(:,2),line_homology(:,3),'markerfaceColor','k','color','blue','linewidth',3);
        hold on;
    end
    indexplot2 = indexplot1;
    nhc2=intersect(homology,find(dimension==2));
    for i=nhc2
        % if dimension of cell is 2 then cell is plotted as patch
        list_vertex = zeros( 4, 3 );
        vertex = zeros( 4, 1 );
        face = zeros( 4, 1 );
        num_vertex = 0;
        for j = boundary((boundary(:,i)>0),i)'
            for k = boundary((boundary(:,j)>0),j)'
                pos_vertex = find( vertex==k, 1 );
                if isempty( pos_vertex )
                    num_vertex = num_vertex + 1;
                    if num_vertex < 3
                        order_face = num_vertex;
                    elseif num_vertex == 3
                        order_face = 4;
                    else
                        order_face = 3;
                    end
                    list_vertex(num_vertex,:) = points(:,k)';
                    vertex(num_vertex) = k;
                    face(order_face) = num_vertex;
                end
            end
        end
        list_face = face';
        indexplot2 = indexplot2 + 1;
        p(indexplot2) = patch( 'Vertices', list_vertex, 'Faces', list_face, 'FaceColor', 'blue', 'FaceAlpha', 0.4 );
        hold on;
    end
    indexplotg = indexplot2;
    for i=intersect(homology,find(dimension==1))
        % g associated to cell 'i' of homology is plotted as group of lines
        list_g=g(g(:,i)>0,i)';
        for j=list_g(list_g~=i)
            line_homology=points(:,boundary(1:2,j)')';
            indexplotg = indexplotg + 1;
            p(indexplotg) = plot3(line_homology(:,1),line_homology(:,2),line_homology(:,3),'markerfaceColor','k','color','yellow','linewidth',3);
            hold on;
        end
    end
    for i=intersect(homology,find(dimension==2))
        % g associated to cell 'i' of homology is plotted as group of
        % patches
        list_g=g(g(:,i)>0,i)';
        for j=list_g(list_g~=i)
            list_vertex = zeros( 4, 3 );
            vertex = zeros( 4, 1 );
            face = zeros( 4, 1 );
            num_vertex = 0;
            for k = boundary((boundary(:,j)>0),j)'
                for l = boundary((boundary(:,k)>0),k)'
                    pos_vertex = find( vertex==l, 1 );
                    if isempty( pos_vertex )
                        num_vertex = num_vertex + 1;
                        if num_vertex < 3
                            order_face = num_vertex;
                        elseif num_vertex == 3
                            order_face = 4;
                        else
                            order_face = 3;
                        end
                        list_vertex(num_vertex,:) = points(:,l)';
                        vertex(num_vertex) = l;
                        face(order_face) = num_vertex;
                    end
                end
            end
            list_face = face';
            indexplotg = indexplotg + 1;
            p(indexplotg) = patch( 'Vertices', list_vertex, 'Faces', list_face, 'FaceColor', 'yellow', 'FaceAlpha', 0.2 );
            hold on;
        end
    end
    
    title('Homology');
    slegend={};
    groups=[];
    gi = hggroup;
    groups=[groups gi];
    set(p(1:1),'Parent',gi);
    slegend{size(slegend,2)+1}='Image';
    if indexplot0>1
        g0 = hggroup;
        groups=[groups g0];
        set(p(2:indexplot0),'Parent',g0);
        slegend{size(slegend,2)+1}=strcat(num2str(size(nhc0,2)),' 0-homology class');
    end
    if indexplot1>indexplot0
        g1 = hggroup;
        groups=[groups g1];
        set(p(indexplot0+1:indexplot1),'Parent',g1);
        slegend{size(slegend,2)+1}=strcat(num2str(size(nhc1,2)),' 1-homology class');
    end
    if indexplot2>indexplot1
        g2 = hggroup;
        groups=[groups g2];
        set(p(indexplot1+1:indexplot2),'Parent',g2);
        slegend{size(slegend,2)+1}=strcat(num2str(size(nhc2,2)),' 2-homology class');
    end
    if indexplotg>indexplot2
        gg = hggroup;
        groups=[groups gg];
        set(p(indexplot2+1:indexplotg),'Parent',gg);
        slegend{size(slegend,2)+1}='g';
    end
    legend(groups,slegend,'Location','BestOutside');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    hold off;
    
end
