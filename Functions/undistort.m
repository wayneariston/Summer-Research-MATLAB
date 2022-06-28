function oulattice = undistort(nlattice, ucalc, atom_diameter, lambda, zscore, climits,cscale, nm1,nm2,linecuts)
    [h,l] = size(nlattice);
    ucalc(isnan(ucalc)) = ucalc(find(isnan(ucalc))-1);

    % assigning default values
    if nargin>3 && ~isempty(lambda)
        if nargin<5
            zscore = 2.58;
        end
    else
        lambda = 0.2;
    end
    z = ceil(zscore/lambda);
    if nargin<6 || isempty(climits)
        climits = [];
    end
    if nargin<7 || isempty(cscale)
        cscale = "";
    end
    if nargin<8 || isempty(nm1) || isempty(nm2)
        nm1 = "undistorted";
        nm2 = "distorted and noisy (cropped)";
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

    [~, ~, Q0, Qx, bragg_max] = myFFT(ulattice,nm1,climits,[],cscale);
    Qx = Qx - 1;
    
    nlattice = nlattice(lima:limb, limc:limd);
    nlattice = (nlattice-mean(nlattice,"all","omitnan"))./std(nlattice,1,"all","omitnan");
    [eight, full] = comboPlot(onlattice,nm2,atom_diameter);
    set(eight, 'CLim', [min(nlattice,[],"all") max(nlattice,[],"all")]);
    set(full, 'CLim', [min(nlattice,[],"all") max(nlattice,[],"all")]);
    line([limc limd], [lima lima], "LineWidth",1, "Color", "r", "LineStyle","-");
    line([limc limd], [limb limb], "LineWidth",1, "Color", "r", "LineStyle","-");
    line([limc limc], [lima limb], "LineWidth",1, "Color", "r", "LineStyle","-");
    line([limd limd], [lima limb], "LineWidth",1, "Color", "r", "LineStyle","-");

    if isempty(climits)
        climits = [0.05 1 bragg_max];
    end
    [~, ~, Qp0, Qpx] = myFFT(nlattice,nm2,climits,[],cscale);
    Qpx = Qpx - 1;
    
    % line cuts
    if nargin>9 && linecuts
        figure;
        width = 40;
        subplot(2,2,1);
        linecutPlot(Q0,[Qx(3) Qx(4)],'x',width);
        hold on
        linecutPlot(Qp0,[Qpx(3) Qpx(4)],'x',width);
        title("Along x");
        xlim([Qx(3)-width/4 Qx(3)+width/4]);
        ylabel("intensity [FFT units]");
        xlabel("x frequency [FFT units]");
        legend("undistorted", "original");
        hold off
        subplot(2,2,3);
        linecutPlot(Q0,[Qx(3) Qx(4)],'y',width);
        hold on
        linecutPlot(Qp0,[Qpx(3) Qpx(4)],'y',width);
        title("Along y");
        xlim([Qx(4)-width/4 Qx(4)+width/4]);
        ylabel("intensity [FFT units]");
        xlabel("y frequency [FFT units]");
        legend("undistorted", "original");
        hold off
        subplot(2,2,2);
        linecutPlot(Q0,[Qx(1) Qx(2)],'x',width);
        hold on
        linecutPlot(Qp0,[Qpx(1) Qpx(2)],'x',width);
        title("Along x");
        xlim([Qx(1)-width/4 Qx(1)+width/4]);
        ylabel("intensity [FFT units]");
        xlabel("x frequency [FFT units]");
        legend("undistorted", "original");
        hold off
        subplot(2,2,4);
        linecutPlot(Q0,[Qx(1) Qx(2)],'y',width);
        hold on
        linecutPlot(Qp0,[Qpx(1) Qpx(2)],'y',width);
        title("Along y");
        xlim([Qx(2)-width/4 Qx(2)+width/4]);
        ylabel("intensity [FFT units]");
        xlabel("y frequency [FFT units]");
        legend("undistorted", "original");
        hold off
        sgtitle("Line cut plots along the peaks in the FFT");
    else
        error("ERROR! What am I supposed to do? -undistort(), on linecuts");
    end
end