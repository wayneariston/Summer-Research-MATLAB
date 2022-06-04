function P = uTransform(s,qx,qy)
    [h,l,~] = size(s);
    [x,y] = meshgrid(1:l,1:h);
    P = cos(qx(1)*(x-squeeze(s(:,:,1)))+qx(2)*(y-squeeze(s(:,:,2))))...
        +cos(qy(1)*(x-squeeze(s(:,:,1)))+qy(2)*(y-squeeze(s(:,:,2))));
    % note the complicated expression
    % That's because I'm assuming that the quantities qx and qy are vectors
end