function convPlot(lat,nm,lat1,lamb,z)
    if nargin>2
        p1 = lat;
        p2 = lat1;
        if strcmp(nm,"biaxial and uniaxial strain")
            t = ["$(\partial_xS_x+\partial_yS_y)/2$" "$(\partial_xS_x-\partial_yS_y)/2$"];
        else
            t = ["x component", "y component"];
        end
        cnm = "scalar magnitude [pixel]";
    else
        p1 = real(lat);
        p2 = imag(lat);
        t = ["real component", "imaginary component"];
        cnm = "Convolution value [intensity]";
    end


    figure;
    colormap(parula);
    subplot(1,2,1);
    imagesc(p1);
    title(t(1),"Interpreter","latex");
    if nargin>3
        [h,l,~] = size(lat);
        if nargin<5
            z = 2.58;
        end
        z = ceil(z/lamb);
        line([1+z l-z], [1+z 1+z], "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line([1+z l-z], [h-z h-z], "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line([1+z 1+z], [1+z h-z], "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line([l-z l-z], [1+z h-z], "LineWidth",1.5, "Color", "k", "LineStyle","--");
        cp1 = p1(1+z:h-z,1+z:l-z);
        cp2 = p2(1+z:h-z,1+z:l-z);
    else
        cp1 = p1;
        cp2 = p2;
    end
    xlabel("$x$ [pixel]","Interpreter","latex");
    ylabel("$y$ [pixel]","Interpreter","latex");
    axis image
    clim([min(min(cp1,cp2),[],"all"), max(max(cp1,cp2),[],"all")]);
%     clim([min(min(p1,p2),[],"all"), max(max(p1,p2),[],"all")]);
    subplot(1,2,2);
    imagesc(p2);
    title(t(2),"Interpreter","latex");
    if nargin>3
        line([1+z l-z], [1+z 1+z], "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line([1+z l-z], [h-z h-z], "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line([1+z 1+z], [1+z h-z], "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line([l-z l-z], [1+z h-z], "LineWidth",1.5, "Color", "k", "LineStyle","--");
    end
    xlabel("$x$ [pixel]","Interpreter","latex");
    ylabel("$y$ [pixel]","Interpreter","latex");
    axis image
    clim([min(min(cp1,cp2),[],"all"), max(max(cp1,cp2),[],"all")]);
%     clim([min(min(p1,p2),[],"all"), max(max(p1,p2),[],"all")]);
    
    % for the common colorbar
    pl = axes('visible', 'off');
    clim([min(min(cp1,cp2),[],"all"), max(max(cp1,cp2),[],"all")]);
%     clim([min(min(p1,p2),[],"all"), max(max(p1,p2),[],"all")]);
    c = colorbar(pl, 'Location','southoutside');
    c.Label.String = cnm;
    c.Label.Interpreter = "Latex";
    ti = sgtitle("Values of " + nm);
    ti.FontSize = 20;
    figure;
end