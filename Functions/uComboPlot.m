function uComboPlot(u,ucalc,lamb,z)
    figure;
    subplot(2,2,1);
    uPlot(u,"$u$");
    subplot(2,2,2);
    uPlot(ucalc,"$u_{calc}$");
    subplot(2,2,3);
    uPlot(ucalc-u,"$u_{calc}-u$");
    subplot(2,2,4);
    colormap(jet);
    imagesc(sqrt(((ucalc(:,:,1)-u(:,:,1)).^2+(ucalc(:,:,2)-u(:,:,2)).^2)./(u(:,:,1).^2+u(:,:,2).^2)),[0.0001 1]);
    hold on
    if nargin>2
        [h,l,~] = size(u);
        if nargin<4
            z = 2.58; % to reduce the influence of edges with padded zeros in the mean difference
        end
        z = ceil(z/lamb);
        line([1+z h-z], [1+z 1+z], "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line([1+z h-z], [l-z l-z], "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line([1+z 1+z], [1+z l-z], "LineWidth",1.5, "Color", "k", "LineStyle","--");
        line([h-z h-z], [1+z l-z], "LineWidth",1.5, "Color", "k", "LineStyle","--");
    end
    title("The magnitude of $(u_{calc}-u)/|u|$","Interpreter","latex");
    xlabel("$x$ [pixel]","Interpreter","latex");
    ylabel("$y$ [pixel]","Interpreter","latex");
    set(gca, "ColorScale","log");
    axis image
    c = colorbar;
    c.Label.String = "Relative error";
    hold off
    figure;
end

