function uPlot(s,nm)
    % s is the 3D array that contains information about the vector field
    
    [h,l,~] = size(s);
    [v,w] = meshgrid(1:l,1:h);
    
    skipx = ceil(50*l/1024);
    skipy = ceil(50*h/1024);
    
    quiver(v(1:skipx:end,1:skipy:end),w(1:skipx:end,1:skipy:end), ...
        s(1:skipx:end,1:skipy:end,1),s(1:skipx:end,1:skipy:end,2),0); % remove 0 to auto-scale
    t = title("Vector field " + nm,"Interpreter","latex");
    xlabel("$x$ distance [pixel]","Interpreter","latex");
    ylabel("$y$ distance [pixel]","Interpreter","latex");
    set(gca,"YDir","reverse");
    axis equal tight;
    t.FontSize = 16;
end