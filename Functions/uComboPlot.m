function uComboPlot(u,ucalc,lamb,z,options)
    arguments
        u; ucalc; lamb = []; z = 2.58;
        options.units = "px";
        options.cf = 1;
        options.cunits = "px";
        options.ccf = 1;
    end
    cf = options.cf;

    imagebox = [1 size(u,1); 1 size(u,2)];
    imagebox = (imagebox)/options.cf;

    figure;
    subplot(2,2,1);
    uPlot(u,"$u$",units=options.units,cf=options.cf, ...
        cunits=options.cunits,ccf=options.ccf);
    subplot(2,2,2);
    uPlot(ucalc,"$u_{calc}$",units=options.units,cf=options.cf, ...
        cunits=options.cunits,ccf=options.ccf);
    subplot(2,2,3);
    uPlot(ucalc-u,"$u_{calc}-u$",units=options.units,cf=options.cf, ...
        cunits=options.cunits,ccf=options.ccf);
    subplot(2,2,4);
    colormap(jet);
    imagesc(imagebox(1,:),imagebox(2,:), ...
        sqrt(((ucalc(:,:,1)-u(:,:,1)).^2+(ucalc(:,:,2)-u(:,:,2)).^2)./(u(:,:,1).^2+u(:,:,2).^2)),[0.0001 1]);
    hold on
    if ~isempty(lamb)
        [h,l,~] = size(u);
        z = ceil(z/lamb);
        line(([1+z l-z])/cf, ([1+z 1+z])/cf, "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line(([1+z l-z])/cf, ([h-z h-z])/cf, "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line(([1+z 1+z])/cf, ([1+z h-z])/cf, "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line(([l-z l-z])/cf, ([1+z h-z])/cf, "LineWidth",1.5, "Color", "k", "LineStyle","--");
    end
    title("The magnitude of $(u_{calc}-u)/|u|$","Interpreter","latex");
    xlabel("$x$ ["+options.units+"]","Interpreter","latex");
    ylabel("$y$ ["+options.units+"]","Interpreter","latex");
    set(gca, "ColorScale","log");
    axis image
    c = colorbar;
    c.Label.String = "Relative error";
    hold off
    figure;
end

