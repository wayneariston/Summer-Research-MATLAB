function [fitresult, gof, output] = createFit(ucalcz, lamb, z, variable, diam)
    [h,l] = size(ucalcz);
    if nargin>1 && ~isempty(lamb)
        if nargin<3
            z = 2.58; % to reduce the influence of edges with padded zeros in the mean difference
        end
        z = ceil(z/lamb);
        ucalcz = ucalcz(1+z:h-z,1+z:l-z);
        xfit = z/l:1/l:(l-z-1)/l;
        yfit = z/h:1/h:(h-z-1)/h;
    else
        xfit = 0:1/l:(l-1)/l;
        yfit = 0:1/h:(h-1)/h;
    end

    [xData, yData, zData] = prepareSurfaceData( xfit, yfit, ucalcz );
    
    if nargin<4
        disp("Doing polynomial fit using MATLAB's poly33.");
        ft = fittype( 'poly33' );
        opts = fitoptions( 'Method', 'LinearLeastSquares' );
    elseif variable~="x" && variable~="y"
        disp("Doing polynomial fit using MATLAB's " + variable + ".");
        ft = fittype( variable );
        opts = fitoptions( 'Method', 'LinearLeastSquares' );
    else
        disp("Doing custom equation fit pre-defined by the author.");
        t = "y+x/" + h;
        hyst_max = (1-exp(-1))*(log(1-exp(-1))+1)+2*exp(-1)-1; % for hyst exponent = 1
        if variable=="x"
            creep_max = (l-1)/l*exp(-(l-1)/(h*l));
            variable = "x-xconst/"+l;
        elseif variable=="y"
            creep_max = (h-1)/h*exp(-(h-1)/h);
            variable = "y-yconst/"+h;
        end
        expr = "a*"+diam+"*("+t+")+" + ...
            "b*"+diam+"*((1-exp(-1))*("+variable+")+exp(-1)-exp(("+variable+")-1))/"+hyst_max+"+" + ...
            "c*"+diam+"*("+variable+")*exp(-("+t+"))/"+creep_max+"+" + ...
            "uconst*"+diam;
        ft = fittype( expr, 'independent', {'x', 'y'}, 'dependent', 'z' );
        opts = fitoptions( 'Method', 'NonLinearLeastSquares' );
        opts.Lower = [-64 0 0 -Inf -1];
        opts.Upper = [64 20 20 Inf 1];
        opts.StartPoint = [0 0 0 0 0];
%         opts.Algorithm = 'Levenberg-Marquardt';
    end
    
    opts.Robust = 'Bisquare';
    [fitresult, gof, output] = fit( [xData, yData], zData, ft, opts );
end