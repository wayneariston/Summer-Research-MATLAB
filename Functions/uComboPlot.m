function uComboPlot(u,ucalc)
    figure;
    subplot(2,2,1);
    uPlot(u,"$u$");
    subplot(2,2,2);
    uPlot(ucalc,"$u_{calc}$");
    subplot(2,2,3);
    uPlot(ucalc-u,"$u-u_{calc}$");
    subplot(2,2,4);
    colormap(jet);
    imagesc(sqrt(((ucalc(:,:,1)-u(:,:,1)).^2+(ucalc(:,:,2)-u(:,:,2)).^2)./(u(:,:,1).^2+u(:,:,2).^2)),[0.0001 1]);
    title("The magnitude of $(u-u_{calc})/|u|$","Interpreter","latex");
    xlabel("$x$ [pixel]","Interpreter","latex");
    ylabel("$y$ [pixel]","Interpreter","latex");
    set(gca, "ColorScale","log");
    axis image
    c = colorbar;
    c.Label.String = "Relative error";
    figure;
end

