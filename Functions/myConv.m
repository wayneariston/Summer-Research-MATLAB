function blat = myConv(lat,qx,qy,lamb,z,~)
    blat = zeros(size(lat));
    sp = size(lat);
    [x,y] = meshgrid(0:sp(2)-1,0:sp(1)-1);
    
    % define the Gaussian
    G = fspecial('gaussian',[sp(1) sp(2)],1/lamb);
    
    % define the other factors to be convoluted
    Fx = lat.*exp(-1i*(qx(1)*x+qx(2)*y));
    Fy = lat.*exp(-1i*(qy(1)*x+qy(2)*y));
    
    % convolve the functions
    lat_x = conv_fft2(Fx,G,'same'); % function downloaded online (credits: David Young, 2011)
    lat_y = conv_fft2(Fy,G,'same');
    
    % same with all the functions, note the vector representations of qx and qy
%     pa = -unwrap(unwrap(angle(lat_x*2),[],2));
%     pb = -unwrap(unwrap(angle(lat_y*2),[],2));
%     pa = -unwrap(unwrap(angle(lat_x*2)),[],2);
%     pb = -unwrap(unwrap(angle(lat_y*2)),[],2);
%     pa = -angle(lat_x*2);
%     pb = -angle(lat_y*2);
%     pa = -unwrap_phase(angle(lat_x*2));
%     pb = -unwrap_phase(angle(lat_y*2));
%     pa = -Unwrap_TIE_DCT_Iter(angle(lat_x*2));
%     pb = -Unwrap_TIE_DCT_Iter(angle(lat_y*2));
%     pa = -unwrap(unwrap(unwrap(angle(lat_x*2),[],2)),[],2);
%     pb = -unwrap(unwrap(unwrap(angle(lat_y*2),[],2)),[],2);
%     pa = -unwrap(unwrap(unwrap(unwrap(angle(lat_x*2),[],2)),[],2));
%     pb = -unwrap(unwrap(unwrap(unwrap(angle(lat_y*2),[],2)),[],2));
    pa = -unwrapGoldstein(lat_x*2);
    pb = -unwrapGoldstein(lat_y*2);

    blat(:,:,1) = (pa*qy(2)-pb*qx(2))./(qx(1)*qy(2)-qy(1)*qx(2));
    blat(:,:,2) = (pa*qy(1)-pb*qx(1))./(qx(2)*qy(1)-qy(2)*qx(1));

    % plot the results
    if nargin<6
        convPlot(lat_x,"T_x");
        convPlot(lat_y,"T_y");
    else
        convPlot(blat(:,:,1),"calculated total distortion",blat(:,:,2),lamb,z);
    end
end