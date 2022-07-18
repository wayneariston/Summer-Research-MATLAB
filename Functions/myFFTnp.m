function Q = myFFTnp(P,diam_out,diam_in)
    % P is the image; Q is the fft
    sp = size(P);
    Q = fft2(P);
    
    % ellipse to create a low-pass filter
    if nargin>1
        eh = sp(1)/(diam_out); % ellipse height
        el = sp(2)/(diam_out); % ellipse length
        ey = ceil(sp(1)/2); % ellipse center y
        ex = ceil(sp(2)/2); % ellipse center x
        [x,y] = meshgrid(0:sp(2)-1,0:sp(1)-1);

        % an asymmetric Gaussian factor is used instead
        mu = [ex ey];
        sigma = [el 0; 0 eh];
        X = [x(:) y(:)];
        ellipse = reshape(mvnpdf(X,mu,sigma),sp(1),sp(2));
        Q = Q.*fftshift(ellipse);
        if nargin>2
            if diam_out>=2.58*diam_in
                error("ERROR! Maximum frequency must be greater than minimum frequency.");
            end
            eh = sp(1)/(diam_in); % ellipse height
            el = sp(2)/(diam_in);
            ey = ceil(sp(1)/2);
            ex = ceil(sp(2)/2);
            ellipse = ((x-ex)/el).^2 + ((y-ey)/eh).^2 <= 1;
            Q(fftshift(ellipse)) = 0;
        end
    end
end