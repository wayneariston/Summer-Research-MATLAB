function blat = lawlerFujita(lat,qx,qy,lamb)
    blat = zeros(size(lat));
    sp = size(lat);
    [x,y] = meshgrid(1:sp(2),1:sp(1));
    
    % define the Gaussian
    G = fspecial('gaussian',[sp(1) sp(2)],1/lamb);
    
    % define the other factors to be convoluted
    Fx = lat.*exp(-1i*(qx(1)*x+qx(2)*y));
    Fy = lat.*exp(-1i*(qy(1)*x+qy(2)*y));
    
    % convolve the functions
    lat_x = conv2(Fx,G,'same');
    lat_y = conv2(Fy,G,'same');
    
    % same with all the functions, note the vector representations of qx and qy
    pa = -unwrap(angle(lat_x*2));
    pb = -unwrap(angle(lat_y*2));
    blat(:,:,1) = (pa*qy(2)-pb*qx(2))./(qx(1)*qy(2)-qy(1)*qx(2));
    blat(:,:,2) = (pa*qy(1)-pb*qx(1))./(qx(2)*qy(1)-qy(2)*qx(1));
end