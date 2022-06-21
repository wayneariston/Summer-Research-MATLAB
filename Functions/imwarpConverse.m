function [blat, mx, my] = imwarpConverse(lat,v,lambda,zscore)
    [h,l] = size(lat);
    [x, y] = meshgrid(1:l,1:h);
    nx = x + squeeze(v(:,:,1));
    ny = y + squeeze(v(:,:,2));
    blat = griddata(nx,ny,lat,x,y,"cubic");
    if nargin>2
        z = ceil(zscore/lambda);
        nx = nx(1+z:h-z,1+z:l-z);
        ny = ny(1+z:h-z,1+z:l-z);
    end
    mx = [ceil(max(nx(:,1)))+1 floor(min(nx(:,end)))-1];
    my = [ceil(max(ny(1,:)))+1 floor(min(ny(end,:)))-1];
end