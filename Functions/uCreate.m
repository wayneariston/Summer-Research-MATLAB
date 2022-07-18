function s = uCreate(h,l,diam,method,distortion_coefficients)
    arguments
        h;l;
        diam = 0;
        method = "poly33";
        distortion_coefficients = zeros(2,10);
    end
    s = zeros(h,l,2);

    % create x and y for spatial dependence
    [x,y] = meshgrid(0:l-1,0:h-1);
    x = x/l; % normalize the distance
    y = y/h;
    
    %create t for temporal dependence (like raster scan)
    t = 0:h*l-1;
    t = reshape(t,[l h])';
    t = t/(h*l); % 1 time unit per l*h pixels (whole image)
        
    if method == "poly33"
        px = distortion_coefficients(1,:);
        py = distortion_coefficients(2,:);
        s(:,:,1) = px(1) + px(2)*x + px(3)*y + px(4)*x.^2 + px(5)*x.*y + ...
            px(6)*y.^2 + px(7)*x.^3 + px(8)*x.^2.*y + px(9)*x.*y.^2 + px(10)*y.^3;
        s(:,:,2) = py(1) + py(2)*x + py(3)*y + py(4)*x.^2 + py(5)*x.*y + ...
            py(6)*y.^2 + py(7)*x.^3 + py(8)*x.^2.*y + py(9)*x.*y.^2 + py(10)*y.^3;
    elseif method == "custom"
        drift = distortion_coefficients(1,1:2);
        hyst = distortion_coefficients(1,3:4);
        creep = distortion_coefficients(1,5:6);

        % thermal drift
        drift_x = t*drift(1)*diam; % drift in atom diameters
        drift_y = t*drift(2)*diam;
        
        % piezoelectric hysteresis
        hyst_x = (1-exp(-1))*x+exp(-1)-exp(x-1);
        hyst_y = (1-exp(-1))*y+exp(-1)-exp(y-1);
        % maximum displacement by hysteresis in atom diameters
        hyst_x = hyst_x/max(abs(hyst_x),[],"all")*hyst(1)*diam;
        hyst_y = hyst_y/max(abs(hyst_y),[],"all")*hyst(2)*diam;
        % note that the exponent (-1 in this case) could be adjusted to change
        % the behavior of the hysteresis curve
        
        % piezoelectric creep
        creep_x = x.*exp(-t);
        creep_y = y.*exp(-t);
        % maximum displacement by creep in atom diameters
        creep_x = creep_x/max(abs(creep_x),[],"all")*creep(1)*diam;
        creep_y = creep_y/max(abs(creep_y),[],"all")*creep(2)*diam;
        % note that the coefficient of t (-1 in this case) could be adjusted to
        % change the behavior of the creep
        
        % change these to change the vector field u
        s(:,:,1) = drift_x+hyst_x+creep_x;
        s(:,:,2) = drift_y+hyst_y+creep_y;
    end
end