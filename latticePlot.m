function latticePlot(P0,nm1,r,num)
    % P0 is the image (uint8); nm1 is the title; r, num specify the view
    
    imagesc(P0);
    colormap(gray);
    axis image
    if nargin<4
        num = 8;
        if nargin>2
            xlim([1 r*num]);
            ylim([1 r*num]);
        end
    else
        xlim([1 r*num]);
        ylim([1 r*num]);
    end
    
    xlabel("$x$ distance [pixel]","Interpreter","latex");
    ylabel("$y$ distance [pixel]","Interpreter","latex");
    t = title("Intensity plot of " + nm1);
    t.FontSize = 16;
end