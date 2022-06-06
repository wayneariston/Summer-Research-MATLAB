function nc = noiseCreate(h,l,diam,minlength,mag)
    % h,l are image dimensions; diam is the atom diameter;
    % minlength is the minimum size of the noise [atom diameter];
    % mag is the noise magnitude [atom diameter]
    if nargin<5
        mag = 1;
    end
    nc = randn(h,l);
    nc = real(ifft2(myFFTnp(nc,diam*minlength)));
    nc = (nc-mean(nc,"all"))/std(nc,1,"all")*diam*mag;
end