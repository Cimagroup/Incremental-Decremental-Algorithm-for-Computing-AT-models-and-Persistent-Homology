function [ f,g,phi,H,cellH ]  = atmodel( points,boundary,ini,fp,gp,phip,Hp,cellHp )
%ATMOTEL This funtion calculates at-model
%   atmodel returns functions f, g, phi and H of at-model. Cells that
%   change homology is returned too

    % Variables points stores coordinate of points that represent the cells
    % of complex cubic
    size_complex = size( points, 2 );
    if isempty(fp)
        % Variables f,g,phi,H and cellH ara initialized with size of points
        % columns
        % Variable f store position of cells that function f returns
        f = zeros( 2, size_complex );
        % Variable g store position of cells that function g returns
        g = zeros( 2, size_complex );
        % Variable phi store position of cells that function phi returns
        phi = zeros( 2, size_complex );
        % Variable H store position of cells that function H returns
        H = zeros( 1, size_complex );
        % Variables cellH store points of cells that change homology
        cellH = zeros( 2, size_complex );
        % First cell creates homology because a new homology class is created.
        % Cell with position 1 is added to homology and it creates homology
        % (H(1) is flagged and cellH(1) stores first position of matrix points)
        f(1,1) = 1;
        g(1,1) = 1;
        phi(1,1) = 0;
        H(1) = 1;
        cellH(1) = 1;
        ini_i = 2;
    else
        f = fp;
        g = gp;
        phi = phip;
        H = Hp;
        cellH = cellHp;
        cellH(size(cellH,1), size_complex) = 0;
        
        ini_i = ini;
    end
    % Others cells are processed
    for i = ini_i:size_complex
        % Boundary of cell processed is calculated
        bound_cell = boundary(:,i);
        bound_cell = boundary(  bound_cell > 0, i );
        if isempty( bound_cell )
            % If boundary of cell doesn't exist then boundaris of f and phi
            % is null
            f_borders=[];
            phi_borders=[];
        else
            % If boundary of cell exists then f and phi of boundary of cell
            % are calculated
            tmp = f(:, bound_cell);
            f_borders = compress( reshape( tmp, size(tmp,1) * size(tmp,2), 1 ) );
            tmp = phi(:, bound_cell);
            phi_borders = compress( reshape( tmp, size(tmp,1) * size(tmp,2), 1 ) );
        end
        % If f(boundary of cell) is null (a new homology class is created)
        % then cell is added to homology: Hi=Hi-1+{cell i},
        % fi(cell-i)=cell-i, gi(cell i)=cell-i+phi i-1(boundary(cell i)),
        % phi i(cell i)=0
        if isempty( f_borders )

            f(:,i) = [i; zeros( size(f,1) - 1, 1 )];
            tmp = compress( [i; phi_borders] );
            if size(tmp,1) > size (g,1)
                g(size(tmp,1),i) = 0;
            end
            g(:,i) = [tmp; zeros( size(g,1) - size(tmp,1), 1 )];
            phi(:,i) = 0;
            H(i) = 1;

            if isempty( find(cellH(:,i)==0,1) )
                cellH(size(cellH,1)+1, i) = 0;
            end
            cellH(find(cellH(:,i)==0,1), i) = i;

        else
            % A homology class is destroyed
            % fi(cell i)=0
            f(:,i) = 0;
            % gi(cell i)=0
            g(:,i) = 0;
            % phi i(cell i)=0
            phi(:,i) = 0;
            % Hi=Hi-1-{cell i}
            H(i) = 0;
            % cell j exist in fi-1(boundary(cell i)) / j is maximum
            j_max = max(f_borders);
            % gi-1(j)=0
            g(:,j_max) = 0;
            % Hi=Hi-1-{cell j}
            H(:,j_max) = 0;
            % Variable cellH store cell j that destroyed homology
            if isempty( find(cellH(:,j_max)==0,1) )
                cellH(size(cellH,1)+1, j_max) = 0;
            end
            cellH(find(cellH(:,j_max)==0,1), j_max) = i;
            % Exist x / cell j exist fi-1(x)
            fx = f(:,1:i-1);
            [~, X] = find(fx==j_max);
            % For all x / cell j exist fi-1(x)
            for x=X'
                % fi(x)=fi-1(x)+fi-1(boundary(cell i))
                tmp=compress( [f(:,x); f_borders] );
                if size(tmp,1) > size (f,1)
                    f(size(tmp,1),x) = 0;
                end
                f(:,x) = [tmp; zeros( size(f,1) - size(tmp,1), 1 )];
                % phi i(x)=phi i-1(x)+cell i+phi i-1(boundary(celll i))
                tmp=compress( [phi(:,x); i; phi_borders] );
                if size(tmp,1) > size (phi,1)
                    phi(size(tmp,1),x) = 0;
                end
                phi(:,x) = [tmp; zeros( size(phi,1) - size(tmp,1), 1 )];
            end
            
        end
        
    end
    % Sparse matrices created for g, phi and H free memory
    g = sparse(g);
    phi = sparse(phi);
    H = sparse(H);
    
end
