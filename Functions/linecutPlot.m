function linecutPlot(values, index, direction, width)
    if nargin<4
        width = 10;
    end
    [nh, nl] = size(values);
    
    % to adjust for the indexing offset
    index(1) = floor(nl/2)+index(1)+1;
    index(2) = floor(nh/2)+index(2)+1;
    
    if direction=='x'
        if (index(1)>=1+width) && (index(1)<=nl-width)
            range = index(1)-width:index(1)+width;
        elseif index(1)<1+width
            range = 1:index(1)+width;
        else
            range = index(1)-width:nl;
        end
        plot(range-floor(nl/2)-1,values(index(2),range));
    elseif direction=='y'
        if (index(2)>=1+width) && (index(2)<=nh-width)
            range = index(2)-width:index(2)+width;
        elseif index(2)<1+width
            range = 1:index(2)+width;
        else
            range = index(2)-width:nh;
        end
        plot(range-floor(nh/2)-1,values(range,index(1)));
    else
        error("Direction could only be 'x' or 'y'.");
    end
end