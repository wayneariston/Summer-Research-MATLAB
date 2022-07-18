function blat = lawlerFujita(lat,qx,qy,lamb,z,fast)
    sp = size(lat);
    [x,y] = meshgrid(0:sp(2)-1,0:sp(1)-1);
    
    if nargin>5
        if fast
            if isempty(z)
                z = 2.58; % to reduce the influence of edges with padded zeros in the mean difference
            end
            z = ceil(z/lamb);
            sp = 2*z*[1 1];
            convMode = 'valid';
            blat = zeros(size(lat)-sp+[1 1]);
        else
            error("What am I supposed to do? -lawlerFujita()");
        end
    else
        convMode = 'same';
        blat = zeros(sp);
    end
    
    % define the Gaussian
    G = fspecial('gaussian',[sp(1) sp(2)],1/lamb);
    
    % define the other factors to be convoluted
    Fx = lat.*exp(-1i*(qx(1)*x+qx(2)*y));
    Fy = lat.*exp(-1i*(qy(1)*x+qy(2)*y));
    
    % convolve the functions
    lat_x = conv_fft2(Fx,G,convMode); % function downloaded online (credits: David Young, 2011)
    lat_y = conv_fft2(Fy,G,convMode);
    
    % same with all the functions, note the vector representations of qx and qy
    pa = -unwrap(unwrap(angle(lat_x*2),[],2));
    pb = -unwrap(unwrap(angle(lat_y*2),[],2));
    
    blat(:,:,1) = (pa*qy(2)-pb*qx(2))./(qx(1)*qy(2)-qy(1)*qx(2));
    blat(:,:,2) = (pa*qy(1)-pb*qx(1))./(qx(2)*qy(1)-qy(2)*qx(1));
end