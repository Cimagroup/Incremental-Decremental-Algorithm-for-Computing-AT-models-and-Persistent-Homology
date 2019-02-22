function viewbarcode( barcode )
%VIEWHOMOLOGY This function view barcode
%   View barcod calculated in process construction of at-model

    % 'cla' is used for clearing axes
    %cla;
    figure;
    hold on;
    
    barcode0 = barcode{1};
    barcode1 = barcode{2};
    barcode2 = barcode{3};

    % Cells of dimension 0 (vertexs) are processed
    indexplot0 = 0;
    for i=1:size(barcode0,2)
        if i==1
            index_j = find(barcode0(:,i)>0)';
        else
            index_j = find(barcode0(:,i)-barcode0(:,i-1)>0)';
        end
        for j=index_j
            k = i+1;
            while k<=size(barcode0,2) && barcode0(j,k)==1
                k = k+1;
            end
            k = k-1;
            indexplot0 = indexplot0+1;
            p(indexplot0) = plot( [i-0.1,k+0.1],[indexplot0,indexplot0],'Color','Blue','LineWidth',5 );
        end
    end
    
    % Cells of dimension 1 (lines) are processed
    indexplot1 = indexplot0;
    for i=2:size(barcode1,2)
        if i==1
            index_j = find(barcode1(:,i)>0)';
        else
            index_j = find(barcode1(:,i)-barcode1(:,i-1)>0)';
        end
        for j=index_j
            k = i+1;
            while k<=size(barcode1,2) && barcode1(j,k)==1
                k = k+1;
            end
            k = k-1;
            indexplot1 = indexplot1+1;
            p(indexplot1) = plot( [i-0.1,k+0.1],[indexplot1,indexplot1],'Color','Red','LineWidth',5 );
        end
    end

    % Cells of dimension 2 (faces) are processed
    indexplot2 = indexplot1;
    for i=1:size(barcode2,2)
        if i==1
            index_j = find(barcode2(:,i)>0)';
        else
            index_j = find(barcode2(:,i)-barcode2(:,i-1)>0)';
        end
        for j=index_j
            k = i+1;
            while k<=size(barcode2,2) && barcode2(j,k)==1
                k = k+1;
            end
            k = k-1;
            indexplot2 = indexplot2+1;
            p(indexplot2) = plot( [i-0.1,k+0.1],[indexplot2,indexplot2],'Color','Green','LineWidth',5 );
        end
    end
    
    title('Barcode');
    slegend={};
    groups=[];
    if indexplot0>0
        g0 = hggroup;
        groups=[groups g0];
        set(p(1:indexplot0),'Parent',g0);
        slegend{size(slegend,2)+1}='dim0';
    end
    if indexplot1>indexplot0
        g1 = hggroup;
        groups=[groups g1];
        set(p(indexplot0+1:indexplot1),'Parent',g1);
        slegend{size(slegend,2)+1}='dim1';
    end
    if indexplot2>indexplot1
        g2 = hggroup;
        groups=[groups g2];
        set(p(indexplot1+1:indexplot2),'Parent',g2);
        slegend{size(slegend,2)+1}='dim2';
    end
    legend(groups,slegend,'Location','BestOutside');
    xlabel('cameras');
    ylabel('class homology');
    axis auto;
    %xlim([0 size(barcode0,2)]);
    ylim([0 size(barcode0,1)+size(barcode1,1)+size(barcode2,1)+1]);
    daspect([1,1,1]);
    grid off;
    hold off;
    
end
