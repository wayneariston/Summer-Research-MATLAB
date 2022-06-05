tic
image_length = 128;
image_height = 128;
atom_diameter = 8;
lambda = 3; % [rad atom^-1]
% lambda should be <<1, but not too small as well
lambda = lambda*2*pi/atom_diameter;

Q_x = [1 0];
Q_y = [-Q_x(2) Q_x(1)]; % just to ensure orthogonality
Q_x = Q_x * 2*pi / (norm(Q_x)*atom_diameter); % [rad atom^-1]
Q_y = Q_y * 2*pi / (norm(Q_y)*atom_diameter); % [rad atom^-1]

inputs = zeros(6);
a = 0;
meanErr = zeros(1);

while a<=10
    % create a displacement vector field
    u = uCreate(image_height,image_length,atom_diameter,[a 0],[0 0],[0 0]);
    % the third parameter specifies the atom diameter
    % the first vector is the x,y drift speed [atom diameter per time unit]
    % the second vector is the x,y maximum displacement from hysteresis [atom diameter]
    % the third vector is the x,y for creep [atom diameter]

    % distort a perfect lattice with the vector field above
    lattice1 = normies(uTransform(u,Q_x,Q_y))*atom_diameter/2;

    % calculate for the vector field using the Lawler-Fujita algorithm
    ucalc = lawlerFujita(lattice1,Q_x,Q_y,lambda);
    [meanErr(uint16(a*100)+1), stdErr, ouah] = uCompare(u,ucalc,lambda);
    a = a + 0.01;
end
toc

figure;
plot(0:0.01:double(uint8(a)-0.01),meanErr);
xlabel("max value of distortion [atom diameter]");
ylabel("relative error");

a = 0;
meanErr = zeros(1);

while a<=10
    u = uCreate(image_height,image_length,atom_diameter,[0 a],[0 0],[0 0]);
    lattice1 = normies(uTransform(u,Q_x,Q_y))*atom_diameter/2;
    ucalc = lawlerFujita(lattice1,Q_x,Q_y,lambda);
    [meanErr(uint16(a*100)+1), stdErr, ouah] = uCompare(u,ucalc,lambda);
    a = a + 0.01;
end
toc

hold on
plot(0:0.01:double(uint8(a)-0.01),meanErr);
xlabel("max value of distortion [atom diameter]");
ylabel("relative error");

a = 0;
meanErr = zeros(1);

while a<=10
    u = uCreate(image_height,image_length,atom_diameter,[0 0],[a 0],[0 0]);
    lattice1 = normies(uTransform(u,Q_x,Q_y))*atom_diameter/2;
    ucalc = lawlerFujita(lattice1,Q_x,Q_y,lambda);
    [meanErr(uint16(a*100)+1), stdErr, ouah] = uCompare(u,ucalc,lambda);
    a = a + 0.01;
end
toc

plot(0:0.01:double(uint8(a)-0.01),meanErr);
xlabel("max value of distortion [atom diameter]");
ylabel("relative error");

a = 0;
meanErr = zeros(1);

while a<=10
    u = uCreate(image_height,image_length,atom_diameter,[0 0],[0 a],[0 0]);
    lattice1 = normies(uTransform(u,Q_x,Q_y))*atom_diameter/2;
    ucalc = lawlerFujita(lattice1,Q_x,Q_y,lambda);
    [meanErr(uint16(a*100)+1), stdErr, ouah] = uCompare(u,ucalc,lambda);
    a = a + 0.01;
end
toc

plot(0:0.01:double(uint8(a)-0.01),meanErr);
xlabel("max value of distortion [atom diameter]");
ylabel("relative error");

a = 0;
meanErr = zeros(1);

while a<=10
    u = uCreate(image_height,image_length,atom_diameter,[0 0],[0 0],[a 0]);
    lattice1 = normies(uTransform(u,Q_x,Q_y))*atom_diameter/2;
    ucalc = lawlerFujita(lattice1,Q_x,Q_y,lambda);
    [meanErr(uint16(a*100)+1), stdErr, ouah] = uCompare(u,ucalc,lambda);
    a = a + 0.01;
end
toc

plot(0:0.01:double(uint8(a)-0.01),meanErr);
xlabel("max value of distortion [atom diameter]");
ylabel("relative error");

a = 0;
meanErr = zeros(1);

while a<=10
    u = uCreate(image_height,image_length,atom_diameter,[0 0],[0 0],[0 a]);
    lattice1 = normies(uTransform(u,Q_x,Q_y))*atom_diameter/2;
    ucalc = lawlerFujita(lattice1,Q_x,Q_y,lambda);
    [meanErr(uint16(a*100)+1), stdErr, ouah] = uCompare(u,ucalc,lambda);
    a = a + 0.01;
end
toc

plot(0:0.01:double(uint8(a)-0.01),meanErr);
xlabel("max value of distortion [atom diameter]");
ylabel("relative error");

legend("drift x", "drift y", "hysteresis x", "hysteresis y", "creep x", "creep y");
title("$\Lambda_u=$" + lambda,"Interpreter","latex");