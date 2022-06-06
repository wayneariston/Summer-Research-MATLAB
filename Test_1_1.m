for ell = 0.2
    disp("Calculation for lambda = " + ell);
    tic
    image_length = 256;
    image_height = 256;
    atom_diameter = 8;
    lambda = ell; % [rad atom^-1]
    % lambda should be <<1, but not too small as well
    % [edit] actually, it can be smaller
    lambda = lambda*2*pi/atom_diameter;
    
    if image_length-2*ceil(2.58/lambda)<=0 && image_height-2*ceil(2.58/lambda)<=0
        error("No pixels without padded zeros remain.");
    else
        npixel = (image_length-2*ceil(2.58/lambda))*(image_height-2*ceil(2.58/lambda));
        % the number of pixels averaged
        disp("Number of pixels averaged: " + npixel + " (" + npixel/(image_length*image_height)*100 + "%)");
    end

    Q_x = [1 0];
    Q_y = [-Q_x(2) Q_x(1)]; % just to ensure orthogonality
    Q_x = Q_x * 2*pi / (norm(Q_x)*atom_diameter); % [rad atom^-1]
    Q_y = Q_y * 2*pi / (norm(Q_y)*atom_diameter); % [rad atom^-1]

    inputs = [1 zeros(1,5)];
    meanErr = zeros(1);
    
    figure;
    
    for ctr = 1:6
        lims = 0:0.01:1;
        for a = lims
            % create a displacement vector field
            u = uCreate(image_height,image_length,atom_diameter,...
                a*[inputs(mod(1-ctr,6)+1) inputs(mod(2-ctr,6)+1)],...
                a*[inputs(mod(3-ctr,6)+1) inputs(mod(4-ctr,6)+1)],...
                a*[inputs(mod(5-ctr,6)+1) inputs(mod(6-ctr,6)+1)]);
            % the third parameter specifies the atom diameter
            % the first vector is the x,y drift speed [atom diameter per time unit]
            % the second vector is the x,y maximum displacement from hysteresis [atom diameter]
            % the third vector is the x,y for creep [atom diameter]

            % distort a perfect lattice with the vector field above
            lattice1 = normies(uTransform(u,Q_x,Q_y))*atom_diameter/2;

            % calculate for the vector field using the Lawler-Fujita algorithm
            ucalc = lawlerFujita(lattice1,Q_x,Q_y,lambda,true);
            [meanErr(round(a*100)+1), stdErr, ouah] = uCompare(u,ucalc,lambda,true);
            % add "true" as last parameter to do fast convolution
            % for both lawlerFujita() and uCompare()
        end
        toc
        plot(lims,meanErr);
        hold on
    end
    xlabel("max value of distortion [atom diameter]");
    ylabel("relative error");
    legend("drift x", "drift y", "hysteresis x", "hysteresis y", "creep x", "creep y");
    title("$\Lambda_u=" + ell + "$","Interpreter","latex");
    ylim([0 2.5]);
    pbaspect([2 1 1]);
    hold off
%     saveas(gcf,"lambda " + ell + ".fig");
end