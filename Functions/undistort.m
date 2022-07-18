function oulattice = undistort(nlattice, ucalc, atom_diameter, lambda, zscore, options)
    % assigning default values
    arguments
        nlattice; ucalc; atom_diameter;
        lambda = 0.2;
        zscore = 2.58;
        options.climits = [];
        options.cscale = "";
        options.cryst_struct = "first";
        options.name_undistorted = "undistorted";
        options.name_cropped = "distorted and noisy (cropped)";
        options.linecuts = false;
        options.units = "default";
        options.cf = 1;
        options.cunits = "px";
        options.ccf = 1;
    end
    
    climits = options.climits;
    cscale = options.cscale;
    cryst_struct = options.cryst_struct;
    nm1 = options.name_undistorted;
    nm2 = options.name_cropped;
    linecuts = options.linecuts;
    
    cf = options.cf;
    cunits = options.cunits;
    ccf = options.ccf;

    [h,l] = size(nlattice);

    [ulattice, mx, my] = imwarpConverse(nlattice,ucalc,lambda,zscore);

    oulattice = ulattice;
%     oulattice = (oulattice-mean(oulattice,"all","omitnan"))./std(oulattice,1,"all","omitnan");
    onlattice = nlattice;
%     onlattice = (onlattice-mean(onlattice,"all","omitnan"))./std(onlattice,1,"all","omitnan");

    lima = max(1,my(1));
    limb = min(h,my(2));
    limc = max(1,mx(1));
    limd = min(l,mx(2));
    spp = [limd-limc+1 limb-lima+1];

    if options.units=="default"
        units = "FFT units";
        divisor = [1 1];
    else
        units = options.units;
        divisor = spp/cf;
    end

    ulattice = ulattice(lima:limb, limc:limd);
%     ulattice = (ulattice-mean(ulattice,"all","omitnan"))./std(ulattice,1,"all","omitnan");
    
    [eight, full, cbar] = comboPlot(oulattice,nm1,atom_diameter,units=options.units,cf=cf,cunits=cunits,ccf=ccf);
    set(eight, 'CLim', [min(ulattice,[],"all") max(ulattice,[],"all")]);
    set(full, 'CLim', [min(ulattice,[],"all") max(ulattice,[],"all")]);
    set(cbar, 'CLim', [0 max(ulattice,[],"all")-min(ulattice,[],"all")]/ccf);
    line(full, [limc limd]/cf, [lima lima]/cf, "LineWidth",1, "Color", "r", "LineStyle","-");
    line(full, [limc limd]/cf, [limb limb]/cf, "LineWidth",1, "Color", "r", "LineStyle","-");
    line(full, [limc limc]/cf, [lima limb]/cf, "LineWidth",1, "Color", "r", "LineStyle","-");
    line(full, [limd limd]/cf, [lima limb]/cf, "LineWidth",1, "Color", "r", "LineStyle","-");

    [~, ~, Q0, Qx, bragg_max] = myFFT(ulattice,nm1, ...
        climits=climits,cscale=cscale,cryst_struct=cryst_struct, ...
        units=options.units,cf=cf,cunits=cunits,ccf=ccf);
    
    nlattice = nlattice(lima:limb, limc:limd);
%     nlattice = (nlattice-mean(nlattice,"all","omitnan"))./std(nlattice,1,"all","omitnan");
    [eight, full, cbar] = comboPlot(onlattice,nm2,atom_diameter,units=options.units,cf=cf,cunits=cunits,ccf=ccf);
    set(eight, 'CLim', [min(nlattice,[],"all") max(nlattice,[],"all")]);
    set(full, 'CLim', [min(nlattice,[],"all") max(nlattice,[],"all")]);
    set(cbar, 'CLim', [0 max(nlattice,[],"all")-min(nlattice,[],"all")]/ccf);
    line(full, [limc limd]/cf, [lima lima]/cf, "LineWidth",1, "Color", "r", "LineStyle","-");
    line(full, [limc limd]/cf, [limb limb]/cf, "LineWidth",1, "Color", "r", "LineStyle","-");
    line(full, [limc limc]/cf, [lima limb]/cf, "LineWidth",1, "Color", "r", "LineStyle","-");
    line(full, [limd limd]/cf, [lima limb]/cf, "LineWidth",1, "Color", "r", "LineStyle","-");

    if isempty(climits)
        climits = [0.05 1 bragg_max];
    end
    [~, ~, Qp0, Qpx] = myFFT(nlattice,nm2, ...
        climits=climits,cscale=cscale,cryst_struct=cryst_struct, ...
        units=options.units,cf=cf,cunits=cunits,ccf=ccf);
    
    % line cuts
    if linecuts
        if cscale=="linear"
            collog = ["", ""];
        else
            collog = ["ln(", ")"];
        end
        width = min(h,l)/16;
        figure;
        np = size(Qx,2);
        dirc = 1;
        for dir = ['x' 'y']
            for ctr = 1:np
                npc = np+1-ctr;
                subplot(2,np,np*(dirc-1)+ctr);
                linecutPlot(Q0,Qx(:,npc),dir,width,units=options.units,cf=cf,cunits=cunits,ccf=ccf);
                hold on
                linecutPlot(Qp0,Qpx(:,npc),dir,width,units=options.units,cf=cf,cunits=cunits,ccf=ccf);
                title("Along " + dir);
                xlim([(Qx(dirc,npc)-width/4-floor(spp(dirc)/2)-1)/divisor(dirc), ...
                    (Qx(dirc,npc)+width/4-floor(spp(dirc)/2)-1)/divisor(dirc)]);
                if cunits~=units
                    ylabel("magnitude ["+collog(1)+cunits+"\cdot"+units+collog(2)+"]");
                else
                    ylabel("magnitude ["+cunits+"^2]");
                end
                xlabel(dir + " frequency ["+units+"^-1]");
                legend("undistorted", "original");
                hold off
            end
            dirc = dirc + 1;
        end
        sgtitle("Line cut plots along the peaks in the FFT");
    else
        error("ERROR! What am I supposed to do? -undistort(), on linecuts");
    end
end