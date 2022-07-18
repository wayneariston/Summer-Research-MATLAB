function linecutPlot(values, index, direction, width, options)
    arguments
        values; index; direction; width = 10;
        options.units = "default";
        options.cf = 1;
        options.cunits = "px";
        options.ccf = 1;
    end
    [nh, nl] = size(values);
    width = ceil(width);
    if options.units=="default"
        options.cf = 1;
        divisor = [1 1];
    else
        divisor = size(values)/options.cf;
    end
    
    if direction=='x'
        if index(1)+width>nl
            range = index(1)-width:nl;
        elseif index(1)-width<1
            range = 1:index(1)+width;
        else
            range = index(1)-width:index(1)+width;
        end
        plot((range-floor(nl/2)-1)/divisor(2),values(index(2),range)/(options.cf*options.ccf));
    elseif direction=='y'
        if index(2)+width>nh
            range = index(2)-width:nh;
        elseif index(2)-width<1
            range = 1:index(2)+width;
        else
            range = index(2)-width:index(2)+width;
        end
        plot((range-floor(nh/2)-1)/divisor(1),values(range,index(1))/(options.cf*options.ccf));
    else
        error("Direction could only be 'x' or 'y'.");
    end
end