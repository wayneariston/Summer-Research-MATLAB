function opt_lambda = lambdaChoose(drift,hyst,creep,noise_minl,noise_mag,weights)
    % A function that chooses the optimal lambda given distortion and noise
    % estimates and preference weights for image proportion removed

% Initial things
    names = ["drift x", "drift y", "hysteresis x", "hysteresis y", "creep x", "creep y"];
    weights = weights/sum(weights);

    if size(drift,1)==1
        if any(abs(drift)>=10)
            drift(abs(drift)>=10) = [10-0.01 10-0.01];
            warning("The absolute value/s of the limit/s of drift was/were greater than or equal to 10. These are set to 10 instead.");
        end
        drift(1,drift~=0) = drift(drift~=0)-0.01;
        drift(2,:) = drift+0.01;
    end
    if size(hyst,1)==1
        if any(abs(hyst)>=10)
            hyst(abs(hyst)>=10) = [10-0.01 10-0.01];
            warning("The absolute value/s of the limit/s of hysteresis was/were greater than or equal to 10. These are set to 10 instead.");
        end
        hyst(1,hyst~=0) = hyst(hyst~=0)-0.01;
        hyst(2,:) = hyst+0.01;
    end
    if size(creep,1)==1
        if any(abs(creep)>=10)
            creep(abs(creep)>=10) = [10-0.01 10-0.01];
            warning("The absolute value/s of the limit/s of creep was/were greater than or equal to 10. These are set to 10 instead.");
        end
        creep(1,creep~=0) = creep(creep~=0)-0.01;
        creep(2,:) = creep+0.01;
    end
    if length(noise_minl)==1
        if abs(noise_minl)>=15
            noise_minl = 15-0.1;
            warning("Maximum of the minimum noise undulation width is greater than or equal to 15. Value is set to 15.");
        end
        if abs(noise_minl)<=1
            noise_minl = 1+0.1;
            warning("Minimum of the minimum noise undulation width is less than or equal to 1. Value is set to 1.");
        end
        noise_minl(1) = noise_minl-0.1;
        noise_minl(2) = noise_minl+0.1;
    end
    if length(noise_mag)==1
        if abs(noise_mag)>=2
            noise_mag = 2-0.01;
            warning("Noise magnitude is greater than or equal to 2. Value is set to 2.");
        end
        if abs(noise_mag)<=0.1
            noise_mag = 0.1+0.01;
            warning("Noise magnitude is less than or equal to 0.1. Value is set to 0.1.");
        end
        noise_mag(1) = noise_mag-0.01;
        noise_mag(2) = noise_mag+0.01;
    end
    
    dist = [drift hyst creep];
    
    if any(dist(2,:)<dist(1,:))
        errcause = find(dist(2,:)<dist(1,:));
        errcont = "";
        for ctr = 1:length(errcause)
            errcont = errcont + " " + names(errcause(ctr));
        end
        error("ERROR! A maximum distortion (in" + errcont + ") is smaller than a minimum.")
    end
    
    dist(3,:) = abs(mean(dist));
    condition = dist(2,:)<0;
    dist(1:2,condition) = [zeros(1,nnz(condition)); -dist(2,condition)];
    condition = dist(1,:).*dist(2,:)<0;
    dist(1:2,condition) = [zeros(1,nnz(condition)); max(-dist(1,condition),dist(2,condition))];
    
    if any(dist(2,:)>10)
        errcause = find(dist(2,:)>10);
        dist(2,errcause) = 10;
        errcont = "";
        for ctr = 1:length(errcause)
            errcont = errcont + " " + names(errcause(ctr));
        end
        warning("The absolute value/s of the limit/s of [" ...
            + errcont + "] was/were greater than 10. These are set to 10 instead.");
    end
    
    if noise_minl(1)<1
        noise_minl(1) = 1;
        warning("Minimum of the minimum noise undulation width is less than 1. Value is set to 1.");
    end
    if noise_minl(2)<1
        noise_minl(2) = 15;
        warning("Maximum of the minimum noise undulation width is greater than 15. Value is set to 15.");
    end
    if noise_mag(1)<0.1
        noise_mag(1) = 0.1;
        warning("Noise magnitude is less than 0.1. Value is set to 0.1.");
    end
    if noise_mag(2)>2
        noise_mag(2) = 2;
        warning("Noise magnitude is greater than 2. Value is set to 2.");
    end

% import things
    % distortion data
    ella = [0.057:0.001:0.059 0.06:0.005:0.095 0.1:0.01:0.3];
    maglist = 0:0.01:10;
    
    sella = length(ella);
    smaglist = length(maglist);
    
    confidence_level = 0.9999999;
    zscore = zscorer(confidence_level);
    
    meanErrs = zeros(6,smaglist,sella);
    stdErrs = zeros(6,smaglist,sella);
    pixprop = zeros(1,sella);
    
    idx = 1;
    for ell = ella
        load("lambda_" + ell + ".mat");
        meanErrs(:,:,idx) = S.meanErr;
        stdErrs(:,:,idx) = S.stdErr;
        pixprop(idx) = S.pixprop;
        idx = idx + 1;
    end
    
    meanErrs = permute(meanErrs, [3 2 1]);
    stdErrs = permute(stdErrs, [3 2 1]);
    
    % noise data
    nella = [0.1 0.2 0.3];
    
    nminllist = [1 2 5 10 15];
    nmaglist = [0.1:0.1:0.9 1:0.25:2];
    
    load Lambda_vs_noise.mat
    
    nmeanErrs = means;
    nstdErrs = stds;

    queries = 0.057:0.001:0.3;

% interpolate and score
    % distortion
    dsum = zeros(length(queries),6);
    
    for ctr = 1:6
        band = floor(100*dist(1,ctr))+1:ceil(100*dist(2,ctr));
        meanErrIf = interp1(ella,meanErrs(:,band,ctr),queries,"pchip");
        stdErrIf = interp1(ella,stdErrs(:,band,ctr),queries,"pchip");
        dsum(:,ctr) = mean(meanErrIf+stdErrIf*zscore,2);
    end
    
    dscore = mean(dsum.*dist(3,:),2)';
    
    % noise
    minlq = noise_minl(1):0.1:noise_minl(2);
    maglq = noise_mag(1):0.01:noise_mag(2);
    
    [nqueries_min, nqueries_mag] = meshgrid(minlq,maglq);
    
    [nminllistq, nmaglistq] = meshgrid(nminllist,nmaglist);
    
    nmeanErrI = zeros(length(maglq),length(minlq),3);
    nstdErrI = zeros(length(maglq),length(minlq),3);
    
    for ctr = 1:3
        nmeanErrI(:,:,ctr) = interp2(nminllistq,nmaglistq,nmeanErrs(:,:,ctr), ...
            nqueries_min,nqueries_mag,"linear");
        nstdErrI(:,:,ctr) = interp2(nminllistq,nmaglistq,nstdErrs(:,:,ctr), ...
            nqueries_min,nqueries_mag,"linear");
    end
    
    nscore = interp1([0.1 0.2 0.3],squeeze(mean(nmeanErrI+zscore*nstdErrI,[1 2])), ...
        queries,"pchip");
    
    % proportion
    pscore = 1-interp1(ella,pixprop,queries,'spline');
    
    finalscore = weights(1)*dscore+weights(2)*nscore+weights(3)*pscore;
    
    [opt_rel, opt_idx]= min(finalscore);
    opt_lambda = queries(opt_idx);

% plot
    figure;
    plot(queries,finalscore,'LineWidth',1.5);
    hold on
    plot(opt_lambda,opt_rel,'LineStyle','none','Marker','o','MarkerFaceColor','red','HandleVisibility','off');
    plot(queries,weights(1)*dscore);
    plot(queries,weights(2)*nscore);
    plot(queries,weights(3)*pscore);
    xlabel('$\Lambda_u$','Interpreter','latex');
    ylabel('score','Interpreter','latex');
    legend('total score','distortion score','noise score','proportion score','Location','northeast');
    title("$\Lambda_u$ score",'Interpreter','latex');
    hold off
    disp("Optimized lambda = " + opt_lambda);
end