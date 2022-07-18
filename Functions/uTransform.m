function P = uTransform(s,qbragg)
    [h,l,~] = size(s);
    [x,y] = meshgrid(0:l-1,0:h-1);
    P = zeros(h,l);
    for ctr = 1:size(qbragg,2)
        P = P + cos(qbragg(1,ctr)*(x-squeeze(s(:,:,1)))+qbragg(2,ctr)*(y-squeeze(s(:,:,2))));
    end
    P = rescale(P);
end