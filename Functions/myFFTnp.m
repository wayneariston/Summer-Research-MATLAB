function Q = myFFTnp(P,diam)
    % P is the image; Q is the fft
    sp = size(P);
    Q = fft2(P);
    
    % ellipse to create a low-pass filter
    if nargin>1
        eh = sp(1)/(diam); % ellipse height
        el = sp(2)/(diam); % ellipse length
        ey = ceil(sp(1)/2); % ellipse center y
        ex = ceil(sp(2)/2); % ellipse center x
        [x,y] = meshgrid(1:sp(2),1:sp(1));
        ellipse = (x-ex).^2./el^2 + (y-ey).^2./eh^2 <= 1;
        Q(~fftshift(ellipse)) = 0;
    end
end