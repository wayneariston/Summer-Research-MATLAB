function [x,y] = rotateMeshgrid(x,y,theta)
    [xh,xl] = size(x);
    [yh,yh] = size(y);
    if (xh)
    Q = [cos(theta) sin(theta); -sin(theta) cos(theta)];
    vectors = Q*[x(:)';y(:)'];
    x = reshape(squeeze(vectors(1,:)),h,l);
    y = reshape(squeeze(vectors(2,:)),h,l);
end