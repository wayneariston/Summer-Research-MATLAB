function [fitresult, gof, output] = createFit(ucalcz, lamb, z)
    [h,l] = size(ucalcz);
    if nargin>1
        if nargin<3
            z = 2.58; % to reduce the influence of edges with padded zeros in the mean difference
        end
        z = ceil(z/lamb);
        ucalcz = ucalcz(z:h-z,z:l-z);
        xfit = z:l-z;
        yfit = z:h-z;
    else
        xfit = 1:l;
        yfit = 1:h;
    end

    [xData, yData, zData] = prepareSurfaceData( xfit, yfit, ucalcz );
    
    ft = fittype( 'poly33' );
    opts = fitoptions( 'Method', 'LinearLeastSquares' );
    opts.Robust = 'Bisquare';
    
    [fitresult, gof, output] = fit( [xData, yData], zData, ft, opts );
end