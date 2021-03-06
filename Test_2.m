image_length = 128;
image_height = 128;
atom_diameter = 8;
lambda = 0.06; % [rad atom^-1]
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

for mag = [0.1:0.1:1 1.25:0.25:2]
    for maxl = [1 2 5 10 15] % depends on image size/atom size
        tic
        disp("Calculating maxl " + maxl + "d, mag " + mag + "d");
        meanErr = zeros(1,100);
        for ctr = 1:100
            noise = noiseCreate(image_height,image_length,atom_diameter,maxl,mag); % the last two are the parameters of interest
            u = uCreate(image_height,image_length);
            lattice1 = normies(uTransform(u,Q_x,Q_y))*atom_diameter/2+noise;
            ucalc = lawlerFujita(lattice1,Q_x,Q_y,lambda);
            [meanErr(ctr), stdErr] = uCompare(u,ucalc,lambda);
        end
        figure;
        histogram(meanErr)
        hold on
        xline(mean(meanErr), 'LineWidth',3)
        xline(mean(meanErr), 'LineWidth',3,'Color','r')
        title("$\Lambda_u =0.06$, $\vec{u}=\vec{0}$, $\lambda_{max}=" + maxl + "d$, $|noise|=" + mag + "d$, $n = 100$","Interpreter","latex");
        xlabel("absolute error [pixel]");
        ylabel("frequency");
        hold off
%         saveas(gcf,"maxl " + maxl + ", mag " + mag + ".fig");
        toc
    end
end