function [fitresult, gof, output] = createFit(ucalcz, lamb, z, variable, diam, options)
    arguments
        ucalcz;
        lamb = []; z = 2.58;
        variable = []; diam = [];
        options.rot_angle = 0;
    end
    ra = options.rot_angle;

    [h,l] = size(ucalcz);
    if ~isempty(lamb)
        z = ceil(z/lamb);
        ucalcz = ucalcz(1+z:h-z,1+z:l-z);
        xfit = z/l:1/l:(l-z-1)/l;
        yfit = z/h:1/h:(h-z-1)/h;
    else
        xfit = 0:1/l:(l-1)/l;
        yfit = 0:1/h:(h-1)/h;
    end

    % prepare surface data
    [xfit, yfit] = meshgrid(xfit,yfit);
    [xfit, yfit] = rotateMeshgrid(xfit,yfit,ra);
    [xData, yData, zData] = prepareSurfaceData( xfit, yfit, ucalcz );
    
    if isempty(variable)
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