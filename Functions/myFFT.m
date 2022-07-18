function [Q, index, Q1, indextra, sec_max] = myFFT(P, nm, options)
    % P is the image; r, n, noisy specify the colorbar range
    % Q is the fft
    arguments
        P; nm; options.climits = [];
        options.minl = [];
        options.maxl = [];
        options.cscale = 'logarithmic';
        options.cryst_struct = "first";
        options.lattice_constant = 16;
        options.defBragg = [];
        options.units = "default";
        options.cf = 1;
        options.cunits = "px";
        options.ccf = 1;
    end
    dip = options.climits;
    diam = options.minl;
    diamx = options.maxl;
    colorscale = options.cscale;
    cryst_struct = options.cryst_struct;
    if options.units=="default"
        units = "px";
        options.cf = 1;
    else
        units = options.units;
    end
    cf = options.cf;
    cunits = options.cunits;
    ccf = options.ccf;
    
    sp = size(P);
    Q = fft2(P);
    
    % ellipse to create a low-pass filter
    [x,y] = meshgrid(0:sp(2)-1,0:sp(1)-1);
    if ~isempty(diam)
        eh = sp(1)/(diam); % ellipse height
        el = sp(2)/(diam); % ellipse length
        ey = floor(sp(1)/2); % ellipse center y
        ex = floor(sp(2)/2); % ellipse center x

        % an asymmetric Gaussian factor is used instead
        mu = [ex ey];
        sigma = [el 0; 0 eh];
        X = [x(:) y(:)];
        ellipse = reshape(mvnpdf(X,mu,sigma),sp(1),sp(2));
        Q = fftshift(ellipse).*Q;
        nm = nm + " (after low-pass filter)";
        if ~isempty(diamx)
            if 2.58*diam>=diamx
                error("ERROR! Maximum frequency must be greater than minimum frequency.");
            end
            eh = sp(1)/(diamx);
            el = sp(2)/(diamx);
            ellipse = ((x-ex)/el).^2 + ((y-ey)/eh).^2 <= 1;
            Q(fftshift(ellipse)) = 0;
        end
    end

    Q1 = abs(Q);
    if colorscale=="linear"
        collog = ["", ""];
        dipdefault = [0.05 1];
    else
        Q1 = log(Q);
        collog = ["ln(", ")"];
        dipdefault = [0.75 1];
    end

    % to find the Bragg peaks more properly
    cycles_per_size = max(sp)/options.lattice_constant*0.8;
    [index, indextra] = findPeak(Q1,cycles_per_size,options.cryst_struct);

    Q1 = fftshift(Q1);

    % scaling the colorbar
    if isempty(dip)
        dip = dipdefault;
    end
    if length(dip)>2
        sec_max = dip(3);
    else
        sec_max = max(Q1(indextra(2,1), indextra(1,1)), Q1(indextra(2,2), indextra(1,2)));
        if size(indextra,2)>2
            sec_max = max(sec_max,Q1(indextra(1,3), indextra(2,3)));
        end
    end

    figure;
    if options.units=="default"
    imagesc(-floor(sp(2)/2),-floor(sp(1)/2), ...
        Q1/(cf*ccf), sec_max*[dip(1) dip(2)]/(cf*ccf));
        divisor = [1 1];
    else
        divisor = sp/cf;
        imagesc([-floor(sp(2)/2) ceil(sp(2)/2)-1]/divisor(2),[-floor(sp(1)/2) ceil(sp(1)/2)-1]/divisor(1), ...
            Q1/(cf*ccf), sec_max*[dip(1) dip(2)]/(cf*ccf));
    end

    % mark the calculated peaks
    if cryst_struct=="first"
        hold on
        plot([index(1,:) -index(1,:)]/divisor(2),[index(2,:) -index(2,:)]/divisor(1), ...
            Marker="o",MarkerFaceColor="red",MarkerSize=3,MarkerEdgeColor="none", ...
            LineStyle="none",DisplayName="Calculated peaks");
        hold off
        % [optional] mark the defined peaks as well
        if ~isempty(options.defBragg)
            Qbragg = options.defBragg/(2*pi);
            Qbragg(1,:) = Qbragg(1,:)*sp(2);
            Qbragg(2,:) = Qbragg(2,:)*sp(1);
            hold on
            plot([Qbragg(1,:) -Qbragg(1,:)]/divisor(2),[Qbragg(2,:) -Qbragg(2,:)]/divisor(1), ...
                Marker="o",MarkerFaceColor="blue",MarkerSize=3,MarkerEdgeColor="none", ...
                LineStyle="none",DisplayName="Defined peaks");
            hold off
        end
        legend();
    end

    colormap(flipud(gray));
    set(gca,"YDir","normal");
    axis equal tight
    c = colorbar;
    
    if isempty(diam)
        xyl = (max(abs(flipud(indextra)-sp'/2)./(divisor'),[],"all"));
        xlim([-xyl*1.5 xyl*1.5]);
        ylim([-xyl*1.5 xyl*1.5]);
    end
    if options.units=="default"
        xlabel("$x$ frequency [cycles per image length]","Interpreter","latex");
        ylabel("$y$ frequency [cycles per image height]","Interpreter","latex");
    else
        xlabel("$x$ frequency ["+units+"$^{-1}$]","Interpreter","latex");
        ylabel("$y$ frequency ["+units+"$^{-1}$]","Interpreter","latex");
    end
    if units~=cunits
        colorunits = collog(1)+cunits+"$\cdot$"+units+collog(2);
    else
        colorunits = collog(1)+cunits+"$^2$"+collog(2);
    end
    c.Label.String = "Magnitude of the Fourier Transform ["+colorunits+"]";
    c.Label.Interpreter = "Latex";
    t = title("Fourier Transform of image " + nm);
    t.FontSize = 16;

    if cryst_struct=="first"
        if size(index,2) == 2
            disp("myFFT() estimates that the 2D lattice is perfect square.");
        elseif size(index, 2) == 3
            disp("myFFT() estimates that the 2D lattice is perfect hexagonal.");
        end
    end
end