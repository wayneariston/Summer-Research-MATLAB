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
%     [x,y] = meshgrid(0:1/l,(l-1)/l,0:1/h,(h-1)/h);
    strain = zeros(h,l,2);
    area = zeros(h,l,2,'logical');
    for idx = [1,2]
        for smag = -mag:mag/10:mag
            th = rand;
            area(:,:,idx) = imbinarize(rescale(noiseCreate(h,l,diam,minl,1),'InputMin',-2,'InputMax',2),th);
            strain(area) = strain(area) + smag;
        end
    end
    strain = (strain-mean(strain,"all"))/(2.58*std(strain,1,"all"))*mag;
end