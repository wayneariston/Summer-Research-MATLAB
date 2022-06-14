function convPlot(lat,nm,lat1,lamb,z)
    if nargin>2
        p1 = lat;
        p2 = lat1;
        t = ["x component", "y component"];
        cnm = "scalar magnitude [pixel]";
    else
        p1 = real(lat);
        p2 = imag(lat);
        t = ["real component", "imaginary component"];
        cnm = "Convolution value [intensity]";
    end


    figure;
    colormap(gray);
    subplot(1,2,1);
    imagesc(p1);
    title(t(1));
    if nargin>3
        [h,l,~] = size(lat);
        if nargin<5
            z = 2.58;
        end
        z = ceil(z/lamb);
        line([z h-z], [z z], "LineWidth",0.5, "Color", "r", "LineStyle","-");
        line([z h-z], [l-z l-z], "LineWidth",0.5, "Color", "r", "LineStyle","-");
        line([z z], [z l-z], "LineWidth",0.5, "Color", "r", "LineStyle","-");
        line([h-z h-z], [z l-z], "LineWidth",0.5, "Color", "r", "LineStyle","-");
        cp1 = p1(z:h-z,z:l-z);
        cp2 = p2(z:h-z,z:l-z);
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
    title(t(2));
    if nargin>3
        line([z h-z], [z z], "LineWidth",0.5, "Color", "r", "LineStyle","-");
        line([z h-z], [l-z l-z], "LineWidth",0.5, "Color", "r", "LineStyle","-");
        line([z z], [z l-z], "LineWidth",0.5, "Color", "r", "LineStyle","-");
        line([h-z h-z], [z l-z], "LineWidth",0.5, "Color", "r", "LineStyle","-");
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
    t = sgtitle("Values of " + nm);
    t.FontSize = 20;
    figure;
end