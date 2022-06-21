function [Q, index] = myFFT(P, nm, dip, diam)
    % P is the image; r, n, noisy specify the colorbar range
    % Q is the fft
    sp = size(P);
    Q = fft2(P);
    
    % ellipse to create a low-pass filter
    [x,y] = meshgrid(1:sp(2),1:sp(1));
    if nargin>3
        eh = sp(1)/(diam); % ellipse height
        el = sp(2)/(diam); % ellipse length
        ey = ceil(sp(1)/2); % ellipse center y
        ex = ceil(sp(2)/2); % ellipse center x
%         ellipse = (x-ex).^2./el^2 + (y-ey).^2./eh^2 <= 1;
%         Q(~fftshift(ellipse)) = 0;

        % an asymmetric Gaussian factor is used instead
        mu = [ex ey];
        sigma = [el 0; 0 eh];
        X = [x(:) y(:)];
        ellipse = reshape(mvnpdf(X,mu,sigma),sp(1),sp(2));
        Q = fftshift(ellipse).*Q;
        nm = nm + " (after low-pass filter)";
    end
    
    figure;
    Q1 = log(abs(Q));
    Q2 = Q1;
    Q2(isinf(Q2)) = nan;
    cycles_per_size = 32; % to find the Bragg peaks more properly
    circle = ~((x.^2+y.^2>cycles_per_size^2) & (x<=sp(2)/2) & (y<=sp(1)/2));
    Q2(circle) = 0;
    [idy, idx] = find(Q2==max(Q2,[],"all","omitnan"));
    index = [idx(1) idy(1)];
    
    Q1 = fftshift(Q1);
    
    if nargin<3 || ~exist('dip',"var") || isempty(dip)
        dip = [0.75 1];
    end
    
    sec_max = Q2(index(2), index(1));
    imagesc(ceil(-sp(2)/2),ceil(-sp(1)/2),Q1, sec_max*dip);
    colormap(flipud(gray));
    set(gca,"YDir","normal");
    axis equal tight
    c = colorbar;
    
    if nargin<4
        xyl = max(index);
        xlim([-xyl*2.5 xyl*2.5]); % comment these to view whole Fourier transform
        ylim([-xyl*2.5 xyl*2.5]);
    end
    xlabel("$x$ frequency [cycles per image length]","Interpreter","latex");
    ylabel("$y$ frequency [cycles per image height]","Interpreter","latex");
    c.Label.String = "Magnitude of the Fourier Transform [log(8-bit intensity$\cdot$pixel)]";
    c.Label.Interpreter = "Latex";
    t = title("Fourier Transform of image " + nm);
    t.FontSize = 16;
end