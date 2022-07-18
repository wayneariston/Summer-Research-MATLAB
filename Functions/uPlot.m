function uPlot(s,nm, options)
    % s is the 3D array that contains information about the vector field
    arguments
        s; nm;
        options.units = "px";
        options.cf = 1;
        options.cunits = "px";
        options.ccf = 1;
    end
    
    [h,l,~] = size(s);
    [v,w] = meshgrid(0:l-1,0:h-1);
    v = v/options.cf;
    w = w/options.cf;

    % NOTE: values themselves are changed here
    s = s/options.ccf;
    
    skipx = ceil(50*l/1024);
    skipy = ceil(50*h/1024);
    
    quiver(v(1:skipx:end,1:skipy:end),w(1:skipx:end,1:skipy:end), ...
        s(1:skipx:end,1:skipy:end,1),s(1:skipx:end,1:skipy:end,2),0); % remove 0 to auto-scale
    t = title("Vector field " + nm,"Interpreter","latex");
    xlabel("$x$ ["+options.units+"]","Interpreter","latex");
    ylabel("$y$ ["+options.units+"]","Interpreter","latex");
    set(gca,"YDir","reverse");
    axis equal tight;
    t.FontSize = 16;
end