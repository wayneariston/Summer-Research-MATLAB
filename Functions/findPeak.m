function [index, indextra] = findPeak(Q,cps,cryst_struct)
    arguments
        Q; cps;
        cryst_struct = "first";
    end
    [h,l] = size(Q);
    center = [floor(l/2) floor(h/2)].';
    [x,y] = meshgrid(-center(1):l-1-center(1),-center(2):h-1-center(2));
    Q(isinf(Q)) = nan;
    Q = fftshift(Q);

    circle = (x.^2+y.^2<=cps^2) | (y<0) | ((y==0) & (x<0));
    Q(circle) = 0;

    maxvals = zeros(1);
    index = zeros(2,1);
    for ctr = 1:3
        maxvals(ctr) = max(Q,[],"all","omitnan");
        if cryst_struct == "square"
            if ctr>2
                break
            end
        elseif cryst_struct == "first" && maxvals(ctr)<0.4*max(maxvals)
            break
        end
        
        [index(2,ctr), index(1,ctr)] = find(Q == maxvals(ctr),1);
        index(:,ctr) = index(:,ctr)-center-1;

        circle = (x-index(1,ctr)).^2+(y-index(2,ctr)).^2<=cps^2;
        circlecomp = (-x-index(1,ctr)).^2+(-y-index(2,ctr)).^2<=cps^2;
        Q(circle|circlecomp) = 0;
    end

    index = sortrows(index.',1,"descend").';
    indextra = index+center+1;
    index(1,:) = index(1,:)/l;
    index(2,:) = index(2,:)/h;
    if size(index,2)==2
        rot = [0 -1; 1 0];
        antirot = [0 1; -1 0];
        index(:,2) = antirot*index(:,2);
        index(:,1) = mean(index,2);
        index(:,2) = rot*index(:,1);
    elseif size(index,2)==3
        rot = [1/2 -sqrt(3)/2; sqrt(3)/2 1/2];
        antirot = [1/2 sqrt(3)/2; -sqrt(3)/2 1/2];
        index(:,2) = antirot*index(:,2);
        index(:,3) = antirot^2*index(:,3);
        index(:,1) = mean(index,2);
        index(:,2) = rot*index(:,1);
        index(:,3) = rot^2*index(:,1);
    else
        error("Lattice is neither perfect cubic nor perfect hexagonal.");
    end
    index(1,:) = index(1,:)*l;
    index(2,:) = index(2,:)*h;

%     % first quadrant
%     circle = ~((x.^2+y.^2>cps^2) & (x<=l/2) & (y<=h/2));
%     Qp(circle) = 0;
%     [idy1, idx1] = find(Qp==max(Qp,[],"all","omitnan"));
%     id1 = [idx1(1) idy1(1)].';
%     % second quadrant
%     circle = ~(((x-l).^2+y.^2>cps^2) & (x>l/2) & (y<=h/2));
%     Q(circle) = 0;
%     [idy2, idx2] = find(Q==max(Q,[],"all","omitnan"));
%     id2 = [idx2(1) idy2(1)].';
% 
%     if (length(idy1)>1) || (length(idy2)>1)
%         warning("From findPeak(), more than one maximum found.");
%     end
% 
%     index = mean([id1(1)-1,id2(2)-1]);
%     index(2) = mean([id1(2)-1,l-id2(1)-1]);
% 
%     % also return the original ones
%     indextra = [idx1(1) idy1(1) idx2(1)-l idy2(1)];
end