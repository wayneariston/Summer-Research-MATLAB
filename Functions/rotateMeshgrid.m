function [x,y] = rotateMeshgrid(x,y,theta)
    [xh,xl] = size(x);
    [yh,yl] = size(y);
    Q = [cos(theta) sin(theta); -sin(theta) cos(theta)];
    vectors = Q*[x(:)';y(:)'];
    x = reshape(squeeze(vectors(1,:)),xh,xl);
    y = reshape(squeeze(vectors(2,:)),yh,yl);
end