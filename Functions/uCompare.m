function [mu, sigma] = uCompare(u,ucalc,lamb,z,fast)
    [h,l,~] = size(u);
    if nargin<4 || isempty(z)
        z = 2.58; % to reduce the influence of edges with padded zeros in the mean difference
    end
    z = ceil(z/lamb);
    if nargin>4
        if fast
            diffmag = sqrt((u(1+z:h-z,1+z:l-z,1)-ucalc(:,:,1)).^2+(u(1+z:h-z,1+z:l-z,2)-ucalc(:,:,2)).^2);
            umag = sqrt((u(z:h-z,z:l-z,1)).^2+(u(z:h-z,z:l-z,2)).^2);
        else
            error("What am I supposed to do? -uCompare()");
        end
    else
        diffmag = sqrt((u(1+z:h-z,1+z:l-z,1)-ucalc(1+z:h-z,1+z:l-z,1)).^2+(u(1+z:h-z,1+z:l-z,2)-ucalc(1+z:h-z,1+z:l-z,2)).^2);
        umag = sqrt((u(1+z:h-z,1+z:l-z,1)).^2+(u(1+z:h-z,1+z:l-z,2)).^2);
    end
    rel = diffmag./umag;
    rel(isinf(rel)) = nan;
    mu = mean(rel,"all","omitnan");
    sigma = std(rel,1,"all","omitnan");
    if all(isnan(mu))
        warning("All magnitudes of u are zero. Taking absolute error.");
        mu = mean(diffmag,"all");
        sigma = std(diffmag,1,"all");
    end
end