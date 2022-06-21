function ulattice = undistort(nlattice, ucalc, atom_diameter, lambda, zscore,nm1,nm2)
    [h,l] = size(nlattice);
    ucalc(isnan(ucalc)) = ucalc(find(isnan(ucalc))-1);
    if nargin>3 && ~isempty(lambda)
        if nargin<5
            zscore = 2.58;
        end
    else
        lambda = 0.2;
    end
    z = ceil(zscore/lambda);
    if nargin<6
        nm1 = "uD";
        nm2 = "D&N (adjusted)";
    end

    [ulattice, mx, my] = imwarpConverse(nlattice,ucalc,lambda,zscore);

    oulattice = ulattice;
    oulattice = (oulattice-mean(oulattice,"all","omitnan"))./std(oulattice,1,"all","omitnan");
    onlattice = nlattice;
    onlattice = (onlattice-mean(onlattice,"all","omitnan"))./std(onlattice,1,"all","omitnan");

    lima = max(1,my(1));
    limb = min(h,my(2));
    limc = max(1,mx(1));
    limd = min(l,mx(2));
    ulattice = ulattice(lima:limb, limc:limd);
    ulattice = (ulattice-mean(ulattice,"all","omitnan"))./std(ulattice,1,"all","omitnan");
    
    [eight, full] = comboPlot(oulattice,nm1,atom_diameter);
    set(eight, 'CLim', [min(ulattice,[],"all") max(ulattice,[],"all")]);
    set(full, 'CLim', [min(ulattice,[],"all") max(ulattice,[],"all")]);
    line([limc limd], [lima lima], "LineWidth",1, "Color", "r", "LineStyle","-");
    line([limc limd], [limb limb], "LineWidth",1, "Color", "r", "LineStyle","-");
    line([limc limc], [lima limb], "LineWidth",1, "Color", "r", "LineStyle","-");
    line([limd limd], [lima limb], "LineWidth",1, "Color", "r", "LineStyle","-");

    ulattice_fft = myFFT(ulattice,nm1);
    
    nlattice = nlattice(lima:limb, limc:limd);
    nlattice = (nlattice-mean(nlattice,"all","omitnan"))./std(nlattice,1,"all","omitnan");
    [eight, full] = comboPlot(onlattice,nm2,atom_diameter);
    set(eight, 'CLim', [min(nlattice,[],"all") max(nlattice,[],"all")]);
    set(full, 'CLim', [min(nlattice,[],"all") max(nlattice,[],"all")]);
    line([limc limd], [lima lima], "LineWidth",1, "Color", "r", "LineStyle","-");
    line([limc limd], [limb limb], "LineWidth",1, "Color", "r", "LineStyle","-");
    line([limc limc], [lima limb], "LineWidth",1, "Color", "r", "LineStyle","-");
    line([limd limd], [lima limb], "LineWidth",1, "Color", "r", "LineStyle","-");
    nlattice_fft = myFFT(nlattice,nm2);
end