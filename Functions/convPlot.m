function convPlot(lat,nm,lat1,lamb,z,options)
    arguments
        lat; nm; lat1 = [];
        lamb = []; z = 2.58;
        options.units = "px";
        options.cf = 1;
        options.cunits = "px";
        options.ccf = 1;
        options.climits = [];
    end
    units = options.units;
    cf = options.cf;
    cunits = options.cunits;
    ccf = options.ccf;

    if ~isempty(lat1)
        % NOTE: values themselves are changed here
        p1 = lat/ccf;
        p2 = lat1/ccf;

        if length(nm)>1
            t = nm(2:3);
        else
            t = ["x component", "y component"];
        end
        cnm = "scalar magnitude ["+cunits+"]";
    else
        p1 = real(lat);
        p2 = imag(lat);
        t = ["real component", "imaginary component"];
        cnm = "Convolution value [intensity]";
    end


    figure;
    colormap(hot);

    imagebox = [1 size(lat,1); 1 size(lat,2)];
    imagebox = (imagebox)/cf;

    subplot(1,2,1);
    imagesc(imagebox(1,:),imagebox(2,:),p1);
    title(t(1),"Interpreter","latex");
    if ~isempty(lamb)
        [h,l,~] = size(lat);
        z = ceil(z/lamb);
        line(([1+z l-z])/cf, ([1+z 1+z])/cf, "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line(([1+z l-z])/cf, ([h-z h-z])/cf, "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line(([1+z 1+z])/cf, ([1+z h-z])/cf, "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line(([l-z l-z])/cf, ([1+z h-z])/cf, "LineWidth",1.5, "Color", "k", "LineStyle","--");
        cp1 = p1(1+z:h-z,1+z:l-z);
        cp2 = p2(1+z:h-z,1+z:l-z);
    else
        cp1 = p1;
        cp2 = p2;
    end
    xlabel("$x$ ["+units+"]","Interpreter","latex");
    ylabel("$y$ ["+units+"]","Interpreter","latex");
    axis image
    if ~isempty(options.climits)
        climits = options.climits;
    else
        climits = [min(min(cp1,cp2),[],"all"), max(max(cp1,cp2),[],"all")];
    end
    if diff(climits)==0
        climits = [climits(1)-abs(climits(1)) climits(2)+abs(climits(2))];
        disp("Value is constant within the dashed squares in the following plot.");
        if diff(climits)==0
            climits = [-1 1];
            disp("Constant value is 0.");
        end
    end
    clim(climits);

    subplot(1,2,2);
    imagesc(imagebox(1,:),imagebox(2,:),p2);
    title(t(2),"Interpreter","latex");
    if ~isempty(lamb)
        line(([1+z l-z])/cf, ([1+z 1+z])/cf, "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line(([1+z l-z])/cf, ([h-z h-z])/cf, "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line(([1+z 1+z])/cf, ([1+z h-z])/cf, "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line(([l-z l-z])/cf, ([1+z h-z])/cf, "LineWidth",1.5, "Color", "k", "LineStyle","--");
    end
    xlabel("$x$ ["+units+"]","Interpreter","latex");
    ylabel("$y$ ["+units+"]","Interpreter","latex");
    axis image
    clim(climits);
    
    % for the common colorbar
    pl = axes('visible', 'off');
    clim(climits);
    c = colorbar(pl, 'Location','southoutside');
    c.Label.String = cnm;
    c.Label.Interpreter = "Latex";
    ti = sgtitle(nm(1));
    ti.FontSize = 20;
end