function Q = myFFT(P, nm, dip, diam)
    % P is the image; r, n, noisy specify the colorbar range
    % Q is the fft
    sp = size(P);
    Q = fft2(P);
    
    % ellipse to create a low-pass filter
    if nargin>3
        eh = sp(1)/(diam/2); % ellipse height
        el = sp(2)/(diam/2); % ellipse length
        ey = ceil(sp(1)/2); % ellipse center y
        ex = ceil(sp(2)/2); % ellipse center x
        [x,y] = meshgrid(1:sp(2),1:sp(1));
        ellipse = (x-ex).^2./el^2 + (y-ey).^2./eh^2 <= 1;
        Q(~fftshift(ellipse)) = 0;
        nm = nm + " (after low-pass filter)";
    end
    
    Q1 = log(abs(Q));
    Q2 = Q1;
    Q2(isinf(Q2)) = nan;
    Q2(1,1) = 0;
    [~,idx] = max(max(Q2(:,2:end),[],"omitnan"),[],"omitnan");
    [~,idy] = max(max(Q2(2:end,:),[],2,"omitnan"),[],"omitnan");
    
    Q1 = fftshift(Q1);
    
    if nargin<3
        dip = [0.65 1];
    end
    
    if isempty(dip)
        dip = [0.65 1];
    end
    
    sec_max = min(maxk(max(Q1),2)); % for scaling the colorbar
    imagesc(-sp(1)/2,-sp(2)/2,Q1, sec_max*dip);
    colormap(flipud(gray));
    set(gca,"YDir","normal");
    axis equal tight
    c = colorbar;
    
    if nargin<4
        xyl = max(idx,idy);
        xlim([-xyl*2.5 xyl*2.5]); % comment these to view whole Fourier transform
        ylim([-xyl*2.5 xyl*2.5]);
    end
    xlabel("$x$ axis frequency [pixel$^{-1}$]","Interpreter","latex");
    ylabel("$y$ axis frequency [pixel$^{-1}$]","Interpreter","latex");
    c.Label.String = "Magnitude of the Fourier Transform [log(8-bit intensity$\cdot$pixel)]";
    c.Label.Interpreter = "Latex";
    t = title("Fourier Transform of image " + nm);
    t.FontSize = 16;
end