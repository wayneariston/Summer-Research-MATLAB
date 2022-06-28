function [index, indextra] = findPeak(Q,cps)
    [h,l] = size(Q);
    [x,y] = meshgrid(0:l-1,0:h-1);
    Q(isinf(Q)) = nan;
    Qp = Q;
    % first quadrant
    circle = ~((x.^2+y.^2>cps^2) & (x<=l/2) & (y<=h/2));
    Qp(circle) = 0;
    [idy1, idx1] = find(Qp==max(Qp,[],"all","omitnan"));
    % second quadrant
    circle = ~(((x-l).^2+y.^2>cps^2) & (x>l/2) & (y<=h/2));
    Q(circle) = 0;
    [idy2, idx2] = find(Q==max(Q,[],"all","omitnan"));

    if (length(idy1)>1) || (length(idy2)>1)
        warning("From findPeak(), more than one maximum found.");
    end

    index = mean([idx1(1)-1,idy2(1)-1]);
    index(2) = mean([idy1(1)-1,l-idx2(1)-1]);

    % also return the original ones
    indextra = [idx1(1) idy1(1) idx2(1)-l idy2(1)];
end