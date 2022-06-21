function fitPlot(fitresult, zData, nm, lamb, z)
    [h,l] = size(zData);
    xfit = 1:l;
    yfit = 1:h;
    if nargin<5
        z = 2.58;
    end
    z = ceil(z/lamb);
    [xData, yData, zData] = prepareSurfaceData( xfit, yfit, zData);
    meanz = mean(zData,"all");
    rangez = (max(zData,[],"all")-min(zData,[],"all"))*0.75;

    % Plot fit with data.
    figure( 'Name', nm );
    subplot( 2, 1, 1 );
%     pl = plot( fitresult, [xData, yData], zData, 'Style', 'PredObs', 'Level', 0.99);
    pl = plot( fitresult, [xData, yData], zData);
    legend( pl, 'fitted curve', nm + ' vs. x, y', 'Location', 'Southeast', 'Interpreter', 'latex' );
    xlabel( 'x [pixel]', 'Interpreter', 'latex' );
    ylabel( 'y [pixel]', 'Interpreter', 'latex' );
    zlabel( nm + '[pixel]', 'Interpreter', 'latex' );
    set(gca,"YDir","reverse");
    axis equal tight
    shading interp
    patch([1+z 1+z l-z l-z], [1+z 1+z 1+z 1+z], [meanz-rangez meanz+rangez meanz+rangez meanz-rangez],...
        [0 0 0 0],'HandleVisibility','off','FaceColor','red','FaceAlpha',0.3);
    patch([1+z 1+z 1+z 1+z], [1+z 1+z h-z h-z], [meanz-rangez meanz+rangez meanz+rangez meanz-rangez],...
        [0 0 0 0],'HandleVisibility','off','FaceColor','red','FaceAlpha',0.3);
    patch([1+z 1+z l-z l-z], [h-z h-z h-z h-z], [meanz-rangez meanz+rangez meanz+rangez meanz-rangez],...
        [0 0 0 0],'HandleVisibility','off','FaceColor','red','FaceAlpha',0.3);
    patch([l-z l-z l-z l-z], [1+z 1+z h-z h-z], [meanz-rangez meanz+rangez meanz+rangez meanz-rangez],...
        [0 0 0 0],'HandleVisibility','off','FaceColor','red','FaceAlpha',0.3);
    view( -3.5, 16.7 );
    
    % Plot residuals.
    subplot( 2, 1, 2 );
    pl = plot( fitresult, [xData, yData], zData, 'Style', 'Residual' );
    legend( pl, nm + ' - residuals', 'Location', 'Southeast', 'Interpreter', 'latex' );
    % Label axes
    xlabel( 'x [pixel]', 'Interpreter', 'latex' );
    ylabel( 'y [pixel]', 'Interpreter', 'latex' );
    zlabel( nm + '[pixel]', 'Interpreter', 'latex' );
    set(gca,"YDir","reverse");
    daspect([20 20 1]);
    shading interp
    patch([z z l-z l-z], [z z z z], [-rangez rangez rangez -rangez],...
        [0 0 0 0],'HandleVisibility','off','FaceColor','red','FaceAlpha',0.3);
    patch([z z z z], [z z h-z h-z], [-rangez rangez rangez -rangez],...
        [0 0 0 0],'HandleVisibility','off','FaceColor','red','FaceAlpha',0.3);
    patch([z z l-z l-z], [h-z h-z h-z h-z], [-rangez rangez rangez -rangez],...
        [0 0 0 0],'HandleVisibility','off','FaceColor','red','FaceAlpha',0.3);
    patch([l-z l-z l-z l-z], [z z h-z h-z], [-rangez rangez rangez -rangez],...
        [0 0 0 0],'HandleVisibility','off','FaceColor','red','FaceAlpha',0.3);
    view( -3.5, 16.7 );
    sgtitle("$3^{rd}$-degree polynomial fit of " + nm, "Interpreter","latex");
end