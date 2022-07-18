function strain = strainCreate(h,l,diam,mag,minl)
    if nargin<3 || isempty(mag)
        mag = 0.025;
    end
    if nargin<5
        minl = 0.5;
    end
    mag = mag*diam;
    minl = minl*diam;
    if minl<2
        warning("Minimum strain spots width is less than 2 pixels. Value is set to 2 pixels.");
        minl = 2;
    end

    strain = zeros(h,l,2);
    strain(:,:,1) = noiseCreate(h,l,diam,minl/diam,1, true);
    strain(:,:,2) = noiseCreate(h,l,diam,minl/diam,1, true);
    strain = strain*mag;
end