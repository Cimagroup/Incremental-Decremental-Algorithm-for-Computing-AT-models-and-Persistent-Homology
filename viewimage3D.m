function [ output ] = viewimage3D( filename, cameras )
%VIEWIMAGE3D Summary of this function goes here
%   Image obtained from filename for a number of cameras is plotted

    % File 'filename' is opened
    file_identifier = fopen( filename, 'r' );
    % First eight lines ared read
    No_of_lines = 8;
    inputtext = textscan( file_identifier,'%s',No_of_lines,'delimiter','\n', 'BufSize', 16777216 );

    % File is read while number of cameras obtained is distinct to
    % parameter 'cameras'
    while ~feof( file_identifier ) && cameras~=str2double(strrep(inputtext{1}{1},'Cameras used in carving = ',''))
        inputtext = textscan( file_identifier,'%s',No_of_lines,'delimiter','\n', 'BufSize', 16777216 );
    end
    
    % Structure voxel_carving is loaded with list of coordinates x, y, z
    voxel_carving.X = str2num(inputtext{1}{3});
    voxel_carving.Y = str2num(inputtext{1}{5});
    voxel_carving.Z = str2num(inputtext{1}{7});

    % File is closed
    fclose( file_identifier );

    % Structure voxel_carving is plotted
    % 'cla' is used for clearing axes
    cla;
    hold on;
    axis auto;
    grid on;
    view(3);
    daspect('auto');
    rotate3d on;
    plot3(voxel_carving.X,voxel_carving.Y,voxel_carving.Z,'.r','MarkerSize',8);
    title('Image 3D');
    legend('Image');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    hold off;
    
end

