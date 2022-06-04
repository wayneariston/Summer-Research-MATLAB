function convPlot(lat,nm)
    figure;
    colormap(gray);
    subplot(1,2,1);
    imagesc(real(lat));
    title(nm + " (real)");
    xlabel("$x$ [pixel]","Interpreter","latex");
    ylabel("$y$ [pixel]","Interpreter","latex");
    axis image
    subplot(1,2,2);
    imagesc(imag(lat));
    title(nm + " (imaginary)");
    xlabel("$x$ [pixel]","Interpreter","latex");
    ylabel("$y$ [pixel]","Interpreter","latex");
    axis image
    
    % for the common colorbar
    h = axes('visible', 'off');
    caxis(h, [0, 10.6267]);
    c = colorbar(h, 'Location','southoutside');
    c.Label.String = "Convolution value [intensity]";
    c.Label.Interpreter = "Latex";
    figure;
end