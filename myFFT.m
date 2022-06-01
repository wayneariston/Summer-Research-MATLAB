function [Q, idx, idy] = myFFT(P, nm, dip)
    % P is the image; r, n, noisy specify the colorbar range
    % Q is the fft; idx, idy are the indices of Qx, Qy
    
    sp = size(P);
    Q = fft2(P);
    Q1 = log(abs(Q));
    Q2 = Q1;
    Q2(isinf(Q2)) = nan;
    [~,idx] = max(Q2(2:end,1),[],"omitnan");
    [~,idy] = max(Q2(1,2:end),[],"omitnan");
%     idx = idx + 1;  % to make up for the omitted first index
%     idy = idy + 1;
    
    Q1 = fftshift(Q1);
    
    if nargin<3
        dip = [0.65 1];
    end
    
    sec_max = min(maxk(max(Q1),2)); % for scaling the colorbar
    imagesc(-sp(1)/2,-sp(2)/2,Q1, sec_max*dip);
    colormap(flipud(gray));
    set(gca,"YDir","normal");
    axis equal tight
    c = colorbar;
    
    xyl = max(idx,idy);
    xlim([-xyl*2.5 xyl*2.5]); % comment these to view whole Fourier transform
    ylim([-xyl*2.5 xyl*2.5]);
    xlabel("$x$ axis frequency [pixel$^{-1}$]","Interpreter","latex");
    ylabel("$y$ axis frequency [pixel$^{-1}$]","Interpreter","latex");
    c.Label.String = "Magnitude of the Fourier Transform [log(8-bit intensity$\cdot$pixel)]";
    c.Label.Interpreter = "Latex";
    t = title("Fourier Transform of image " + nm);
    t.FontSize = 16;
end