function [ cameras,min_coord,max_coord ] = getcameras( filename )
%COUNT_CAMERAS Summary of this function goes here
%   List of cameras number are obtained from filename

    % File 'filename' is opened
    file_identifier = fopen( filename, 'r' );
    % First eight lines are read
    No_of_lines = 8;
    inputtext = textscan( file_identifier,'%s',No_of_lines,'delimiter','\n', 'BufSize', 16777216 );
    % List of cameras number is initialized
    cameras = [];

    min_coord = [];
    max_coord = [];

    while ~feof( file_identifier )
        % Number of cameras is before of 'Cameras used in carving = '
        cameras = [str2double(strrep(inputtext{1}{1},'Cameras used in carving = ',''));cameras];

        if isempty( min_coord )
            min_coord = [ min( str2num( inputtext{1}{3} )); ...
                    min( str2num( inputtext{1}{5} )); ...
                    min( str2num( inputtext{1}{7} )) ];
            max_coord = [ max( str2num( inputtext{1}{3} )); ...
                    max( str2num( inputtext{1}{5} )); ...
                    max( str2num( inputtext{1}{7} )) ];
        else
            min_coord = [ min( min_coord( 1 ), min( str2num( inputtext{1}{3} ))); ...
                    min( min_coord( 2 ), min( str2num( inputtext{1}{5} ))); ...
                    min( min_coord( 3 ), min( str2num( inputtext{1}{7} ))) ];
            max_coord = [ max( max_coord( 1 ), max( str2num( inputtext{1}{3} ))); ...
                    max( max_coord( 2 ), max( str2num( inputtext{1}{5} ))); ...
                    max( max_coord( 3 ), max( str2num( inputtext{1}{7} ))) ];
        end
        
        % Next eight lines are read
        inputtext = textscan( file_identifier,'%s',No_of_lines,'delimiter','\n', 'BufSize', 16777216 );

    end
    
    cameras = sort(cameras);
    
    % File is closed
    fclose( file_identifier );

end

