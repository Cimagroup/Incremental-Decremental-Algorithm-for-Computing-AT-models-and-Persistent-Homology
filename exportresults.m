function [ ] = exportresults( points,dimension,H,g,cameras_begin,cameras_end )
%EXPORT_RESULTS Summary of this function goes here
%   Detailed explanation goes here

    function cell2csv(filename,cellArray,delimiter)
    % Writes cell array content into a *.csv file.
    % 
    % CELL2CSV(filename,cellArray,delimiter)
    %
    % filename      = Name of the file to save. [ i.e. 'text.csv' ]
    % cellarray    = Name of the Cell Array where the data is in
    % delimiter = seperating sign, normally:',' (it's default)
    %
    % by Sylvain Fiedler, KA, 2004
    % modified by Rob Kohr, Rutgers, 2005 - changed to english and fixed delimiter
        if nargin<3
            delimiter = ',';
        end
    
        datei = fopen(filename,'w');
        for z=1:size(cellArray,1)
            for s=1:size(cellArray,2)
    
                var = eval(['cellArray{z,s}']);
    
                if size(var,1) == 0
                    var = '';
                end
    
                if isnumeric(var) == 1
                    var = num2str(var);
                end
        
                fprintf(datei,var);
        
                if s ~= size(cellArray,2)
                    fprintf(datei,[delimiter]);
                end
            end
            fprintf(datei,'\n');
        end
        fclose(datei);
    end

    [ filename,pathname ] = uiputfile( '*.csv','Export Data','results.csv' );
    
    if ~isempty(filename)
        
        out = {'cameras', 'H', 'dimension', 'g'};
        row = 1;
        
        for cameras=cameras_begin:cameras_end
            
            points_cameras = points{cameras};
            dimension_cameras =dimension{cameras};
            H_cameras = H{cameras};
            g_cameras = g{cameras};
            pointsH = points_cameras(:,H_cameras==1);
            dimensionH = dimension_cameras(:,H_cameras==1);
            gH = g_cameras(:,H_cameras==1);
            for i=1:size(pointsH,2)
                list_gH = '';
                for i_g=1:size(gH(gH(:,i)>0,i)',2)
                    list_gH = strcat( list_gH, ' ', mat2str( points_cameras(:,gH(i_g,i))' ), ' ' );
                end
                row = row + 1;
                out(row,:) = {num2str( cameras ), mat2str( pointsH(:,i)' ), mat2str( dimensionH(i) ), list_gH };
            end
        end
        
        cell2csv( [ pathname,filename ],out );
    
    end

end
