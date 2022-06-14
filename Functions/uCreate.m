function s = uCreate(h,l,diam,drift,hyst,creep)
    s = zeros(h,l,2);
    
    if nargin<3
        diam = 0;
    end
    
    % define optional parameters
    if ~exist("drift","var") || isempty(drift)
        drift = [0 0];
    end
    if ~exist("hyst","var") || isempty(hyst)
        hyst = [0 0];
    end
    if ~exist("creep","var") || isempty(creep)
        creep = [0 0];
    end
    
    % create x and y for spatial dependence
    [x,y] = meshgrid(0:l-1,0:h-1);
    x = x/min(h,l); % normalize the distance
    y = y/min(h,l);
    
    %create t for temporal dependence (like raster scan)
    t = 0:h*l-1;
    t = reshape(t,[l h])';
    t = t/(h*l); % 1 time unit per l*h pixels (whole image)
    
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
    
%     if isnan(s)
%         s = zeros(h,l,2);
%     end
% I forgot what this was for
end