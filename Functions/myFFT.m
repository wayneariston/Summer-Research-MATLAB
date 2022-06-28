function [Q, index, Q1, indextra, sec_max] = myFFT(P, nm, dip, diam, colorscale)
    % P is the image; r, n, noisy specify the colorbar range
    % Q is the fft
    sp = size(P);
    Q = fft2(P);
    
    % ellipse to create a low-pass filter
    [x,y] = meshgrid(0:sp(2)-1,0:sp(1)-1);
    if nargin>3 && nargin<5
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

    if nargin>4 && colorscale=="linear"
        Q1 = abs(Q);
        colorunits = "intensity$\cdot$pixel";
        dipdefault = [0.05 1];
    else
        Q1 = log(abs(Q));
        colorunits = "ln(intensity$\cdot$pixel)";
        dipdefault = [0.75 1];
    end

    % to find the Bragg peaks more properly
    cycles_per_size = max(sp)/32; 
    [index, indextra] = findPeak(Q1,cycles_per_size);

    % scaling the colorbar
    if nargin<3 || ~exist('dip',"var") || isempty(dip)
        dip = dipdefault;
    end
    if length(dip)>2
        sec_max = dip(3);
    else
        sec_max = Q1(indextra(2), indextra(1));
    end

    Q1 = fftshift(Q1);

    figure;
    imagesc(ceil(-sp(2)/2),ceil(-sp(1)/2),Q1, sec_max*[dip(1) dip(2)]);
    colormap(flipud(gray));
    set(gca,"YDir","normal");
    axis equal tight
    c = colorbar;
    
    if nargin<4 || isempty(diam)
        xyl = max(indextra);
        xlim([-xyl*1.5 xyl*1.5]); % comment these to view whole Fourier transform
        ylim([-xyl*1.5 xyl*1.5]);
    end
    xlabel("$x$ frequency [cycles per image length]","Interpreter","latex");
    ylabel("$y$ frequency [cycles per image height]","Interpreter","latex");
    c.Label.String = "Magnitude of the Fourier Transform ["+colorunits+"]";
    c.Label.Interpreter = "Latex";
    t = title("Fourier Transform of image " + nm);
    t.FontSize = 16;
end