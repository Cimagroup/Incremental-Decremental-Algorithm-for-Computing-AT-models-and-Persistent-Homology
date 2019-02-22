function [ points,dimension,boundary,C ] = getcomplex( filename,resolution,cameras,min_coord,Cp,pointsp,dimensionp )
%CALCHOMOLGY Complex (list of points that represent cells, dimension of
%that cells and boundaries of that cells) cubic is generated from filename.
%Resolution is considered for its construction

    % File 'filename' is opened
    file_identifier = fopen( filename, 'r' );
    % First eight lines ared read
    No_of_lines = 8;
    inputtext = textscan( file_identifier,'%s',No_of_lines,'delimiter','\n', 'BufSize', 16777216);

    % File is read while number of cameras obtained is distinct to
    % parameter 'cameras'
    while ~feof(file_identifier) && cameras~=str2double(strrep(inputtext{1}{1},'Cameras used in carving = ',''))
        inputtext = textscan(file_identifier,'%s',No_of_lines,'delimiter','\n', 'BufSize', 16777216);
    end
    
    % Structure voxels is loaded with list of coordinates x, y, z
    voxels = [str2num(inputtext{1}{3});str2num(inputtext{1}{5});str2num(inputtext{1}{7})];

    % File is closed
    fclose( file_identifier );

    if all(all(Cp==zeros(size(Cp))))
        pos = 0;
    else
        pos = size( pointsp, 2);
    end
    C = Cp;
    points(:, 1:size(pointsp,2)) = pointsp;
    dimension(:, 1:size(dimensionp,2)) = dimensionp;

    % Structure voxels is processed
    for i = 1:size(voxels,2)
        % Voxels are normalized. Origin of complex cubix begin in
        % coordinate 1,1,1
        voxel = single( 2 * ( ( voxels(:,i) - min_coord ) / resolution + 1 ) );
        % Variable voxel store position of 3-cell
        % Note: three coordinates of 3-cell are even, two coordinates of
        % 2-cell are even and one coordinate of 2-cell is odd, one
        % coordinate of 1-cell is even, and two coordinates of 1-cell are
        % odd, and thtree coordinates of 1-cell are odd.
        % If i voxel isn't represented in C then i voxel is added
        if C( voxel(1), voxel(2), voxel(3) ) == 0
            % Points that represents the 2-cells of voxel processed are added
            for j = -1:2:1
                for k = -1:2:1
                    for l = -1:2:1
                        if C( voxel(1)+j, voxel(2)+k, voxel(3)+l ) == 0
                            pos=pos+1;

                            C( voxel(1)+j, voxel(2)+k, voxel(3)+l ) = pos;
                            points(:,pos) = voxels(:,i) + [j*resolution/2;k*resolution/2;l*resolution/2];
                            dimension(pos) = 0;
                        end
                    end
                end
            end
            % Points that represents the 1-cells of voxel processed are added
            for j = -1:2:1
                for k = -1:2:1
                    if C( voxel(1)+j, voxel(2)+k, voxel(3) )==0
                        pos=pos+1;
                    
                        C( voxel(1)+j, voxel(2)+k, voxel(3) )=pos;
                        points(:,pos) = voxels(:,i) + [j*resolution/2;k*resolution/2;0];
                        dimension(pos) = 1;
                    end
                end
            end
            for j = -1:2:1
                for k = -1:2:1
                    if C( voxel(1)+j, voxel(2), voxel(3)+k )==0
                        pos=pos+1;

                        C( voxel(1)+j, voxel(2), voxel(3)+k ) = pos;
                        points(:,pos) = voxels(:,i) + [j*resolution/2;0;k*resolution/2];
                        dimension(pos) = 1;
                    end
                end
            end
            for j = -1:2:1
                for k = -1:2:1
                    if C( voxel(1), voxel(2)+j, voxel(3)+k )==0
                        pos=pos+1;

                        C( voxel(1), voxel(2)+j, voxel(3)+k ) = pos;
                        points(:,pos) = voxels(:,i)+[0;j*resolution/2;k*resolution/2];
                        dimension(pos) = 1;
                    end
                end
            end
            % Points that represents the 0-cells of voxel processed are added
            for j = -1:2:1
                if C( voxel(1)+j, voxel(2), voxel(3) )==0
                    pos=pos+1;

                    C( voxel(1)+j, voxel(2), voxel(3) ) = pos;
                    points(:,pos) = voxels(:,i)+[j*resolution/2;0;0];
                    dimension(pos) = 2;
                end
            end
            for j = -1:2:1
                if C( voxel(1), voxel(2)+j, voxel(3) )==0
                    pos=pos+1;
                    
                    C( voxel(1), voxel(2)+j, voxel(3) ) = pos;
                    points(:,pos) = voxels(:,i)+[0;j*resolution/2;0];
                    dimension(pos) = 2;
                end
            end
            for j = -1:2:1
                if C( voxel(1), voxel(2), voxel(3)+j )==0
                    pos=pos+1;
                    
                    C( voxel(1), voxel(2), voxel(3)+j ) = pos;
                    points(:,pos) = voxels(:,i)+[0;0;j*resolution/2];
                    dimension(pos) = 2;
                end
            end

            pos=pos+1;              
            
            C( voxel(1), voxel(2), voxel(3) ) = pos;
            points(:,pos) = voxels(:,i);
            dimension(pos) = 3;
        end
        
    end

    % Positions not stored of variables points, dimension ard cleared
    points = points(:,1:pos);
    dimension = dimension(1:pos);
    % Variable boundary is initialized with six rows and size of points
    % columns. Rows store list of cell boundary.
    boundary = zeros( 6, size(points,2) );

    % Everey boundary for each cell of complex is calculated
    for i = 1:size(points,2)
        % Variable cell store the point normalized
        cell = single( 2* ( ( points(:,i) - min_coord ) / resolution + 1 ) );
        % Boundary of cell is calculated
        bound_cell = boundarycell( cell );
        % If point represents a 0-cell then [0 0 0 0 0 0 ] is added to
        % boubdary matrix
        if isempty( bound_cell ) == 0
            bound_cell = C( bound_cell(1,:) + ...
                ( bound_cell(2,:) - 1 ) * size(C,1) + ...
                ( bound_cell(3,:) - 1 ) * size(C,1) * size(C,2) );
            boundary(:,i) = [bound_cell';zeros(6-size(bound_cell,2),1)];
        end
    end
        
end
