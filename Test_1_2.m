image_length = 256; % [pixel]
image_height = 256; % [pixel]
atom_diameter = 8; % [pixel]

Q_x = [1 0]; % [atom^-1]
Q_y = [-Q_x(2) Q_x(1)]; % just to ensure orthogonality

confidence_level = 0.9999999;

Q_x = Q_x * 2*pi / (norm(Q_x)*atom_diameter);
Q_y = Q_y * 2*pi / (norm(Q_y)*atom_diameter);
zscore = zscorer(confidence_level);

inputs = [1 zeros(1,5)];
skip = 0.01;
lims = 0:skip:10;

meanErr = zeros(6,round(1/skip)+1);
stdErr = zeros(6,round(1/skip)+1);

ella = [0.057:0.001:0.059 0.06:0.005:0.095 0.1:0.01:0.3];

for ell = ella(21)
    tic
    disp("Calculation for lambda = " + ell);
    
    lambda = ell;
    lambda = lambda*2*pi/atom_diameter;
    
    if image_length-2*ceil(zscore/lambda)<=0 && image_height-2*ceil(zscore/lambda)<=0
        error("No pixels without padded zeros remain.");
    else
        npixel = (image_length-2*ceil(zscore/lambda))*(image_height-2*ceil(zscore/lambda));
        % the number of pixels averaged
        pixprop = npixel/(image_length*image_height);
        disp("Number of pixels averaged: " + npixel + " (" + pixprop*100 + "%)");
    end
    
    figure;
    
    for ctr = 1:6
        for a = lims
            % create a displacement vector field
            u = uCreate(image_height,image_length,atom_diameter,...
                a*[inputs(mod(1-ctr,6)+1) inputs(mod(2-ctr,6)+1)],...
                a*[inputs(mod(3-ctr,6)+1) inputs(mod(4-ctr,6)+1)],...
                a*[inputs(mod(5-ctr,6)+1) inputs(mod(6-ctr,6)+1)]);
            
            lattice1 = normies(uTransform(u,Q_x,Q_y))*atom_diameter/2;
            
            ucalc = lawlerFujita(lattice1,Q_x,Q_y,lambda,zscore);
            [meanErr(ctr,round(a/skip)+1), stdErr(ctr,round(a/skip)+1)] = uCompare(u,ucalc,lambda,zscore);
            % add "true" as last parameter to do fast convolution
            % for both lawlerFujita() and uCompare()
        end
        plot(lims,meanErr(ctr,:)+stdErr(ctr,:)*zscore);
        hold on
    end
    xlabel("max value of distortion [atom diameter]");
    ylabel("maximum relative error (99%+ confidence)");
    legend("drift x", "drift y", "hysteresis x", "hysteresis y", "creep x", "creep y");
    title("$\Lambda_u=" + ell + "$","Interpreter","latex");
    ylim([0 1]);
    pbaspect([2 1 1]);
    hold off
    saveas(gcf,"lambda_" + ell + ".fig");
    S = struct('meanErr',meanErr, 'stdErr',stdErr, 'pixprop',pixprop);
    save("lambda_" + ell + ".mat", 'S');
    toc
end