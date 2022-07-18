function latticePlot(P0,nm1,r,num, options)
    % P0 is the image (uint8); nm1 is the title; r, num specify the view
    arguments
        P0; nm1; r = []; num = 8;
        options.units = "px";
        options.cf = 1;
        options.cunits = "px";
        options.ccf = 1;
    end

    imagebox = [1 size(P0,2); 1 size(P0,1)];
    imagebox = (imagebox)/options.cf;
    
    imagesc(imagebox(1,:),imagebox(2,:),P0);
    colormap(gray);
    axis image
    if ~isempty(r) && ~isempty(num)
        xlim(([1 r*num])/options.cf);
        ylim(([1 r*num])/options.cf);
    end
    
    xlabel("$x$ distance ["+options.units+"]","Interpreter","latex");
    ylabel("$y$ distance ["+options.units+"]","Interpreter","latex");
    t = title(nm1);
    t.FontSize = 14;
end