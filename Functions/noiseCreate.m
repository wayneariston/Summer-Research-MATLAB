function nc = noiseCreate(h,l,diam,minlength,mag,nstrain)
    % h,l are image dimensions; diam is the atom diameter;
    % minlength is the minimum size of the noise [atom diameter];
    % mag is the noise magnitude [atom diameter]
    if nargin<5
        mag = 1;
    end
    nc = randn(h,l);
    if nargin>5 && nstrain
        nc = real(ifft2(myFFTnp(nc,diam*minlength,min(h,l)/2)));
        % to avoid cubic varying noise/strain
    end
    nc = real(ifft2(myFFTnp(nc,diam*minlength)));
    nc = (nc-mean(nc,"all"))/std(nc,1,"all")*diam*mag;
end