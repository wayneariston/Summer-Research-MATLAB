function blat = myConv(lat,qbragg,lambda,zscore,plotting,options)
    arguments
        lat; qbragg;
        lambda = 0.2;
        zscore = 2.58;
        plotting = "total";
        options.units = "px";
        options.cf = 1;
        options.cunits = "px";
        options.ccf = 1;
    end
    

    blat = zeros(size(lat));
    sp = size(lat);
    [x,y] = meshgrid(0:sp(2)-1,0:sp(1)-1);
    
    % define the Gaussian
    G = fspecial('gaussian',[sp(1) sp(2)],1/lambda);
    
    p = zeros([sp size(qbragg,2)]);
    for ctr = 1:size(qbragg,2)
        % define the other factors to be convoluted
        F = lat.*exp(-1i*(qbragg(1,ctr)*x+qbragg(2,ctr)*y));
        % convolve the functions
        latb = conv_fft2(F,G,'same'); % function downloaded online (credits: David Young, 2011)
        % unwrap the phase angles
        p(:,:,ctr) = -unwrapGoldstein(latb*2); % function downloaded online (credits: Carey Smith, 2010)
    end

    % uses only two of the calculated scalar fields
    qx = squeeze(qbragg(:,1)); qy = squeeze(qbragg(:,2));
    pa = squeeze(p(:,:,1)); pb = squeeze(p(:,:,2));
    blat(:,:,1) = (pa*qy(2)-pb*qx(2))./(qx(1)*qy(2)-qy(1)*qx(2));
    blat(:,:,2) = (pa*qy(1)-pb*qx(1))./(qx(2)*qy(1)-qy(2)*qx(1));

    % interpolate for the nans
    blat(:,:,1) = inpaint_nans(squeeze(blat(:,:,1)),2); % function downloaded online (credits: John D'Errico, 2009)
    blat(:,:,2) = inpaint_nans(squeeze(blat(:,:,2)),2);

    % plot the results
    if plotting=="decompose"
        convPlot(lat_x,"Values of T_x",units=options.units,cf=options.cf, ...
            cunits=options.cunits,ccf=options.ccf);
        convPlot(lat_y,"Values of T_y",units=options.units,cf=options.cf, ...
            cunits=options.cunits,ccf=options.ccf);
    elseif plotting=="total"
        convPlot(blat(:,:,1),"Calculated total distortion",blat(:,:,2), ...
            lambda,zscore,units=options.units,cf=options.cf, ...
            cunits=options.cunits,ccf=options.ccf);
    end
end