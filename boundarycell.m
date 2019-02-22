function border = boundarycell( cell )
%BOUNDARY_CELL Summary of this function goes here
%   boundarycell returns boundary of cell

    % Variables border and num_border are initialized
    border = zeros( 3, 6 );
    num_border = 0;
    % i is index for processing all coordinates of point that represents to
    % cell
    for i = 1:3
        % If coordinate (1 is X, 2 is Y, 3 is Z) is even then coordinate(i)-1
        % and coordinate(i)+1 are added as borders of cell
        % Note: Origen of complex cubic start in point (1,1,1)
        if mod( cell(i), 2 ) == 0
            num_border = num_border + 1;
            border(:,num_border) =  cell;
            border(i,num_border) = border(i,num_border) - 1;
            
            num_border = num_border + 1;
            border(:,num_border) =  cell;
            border(i,num_border) = border(i,num_border) + 1;
        end
    end
    
    border = border(:,1:num_border);

end

