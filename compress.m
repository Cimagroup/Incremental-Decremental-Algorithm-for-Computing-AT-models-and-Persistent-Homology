function out = compress( list )
%COMPRESS Delete elements duplicates of list
%   Delete elements duplicates of list

    % Variable out stores elements of list not duplicates
    out = zeros( size(list,1), 1 );
    out_size = 0;

    % Only elements positive (not zeros) are processed
    for i = find( list>0 )'
        % Element 'i' is added if number of occurrences is odd and element
        % doesn't exist in variable 'out'
        if mod( size( find( list==list(i) ), 1 ), 2 )==1 && ...
                isempty( find( out==list(i), 1 ) )
            out_size = out_size + 1;
            out(out_size) = list(i);
        end
    end

    out = out(1:out_size);
end
