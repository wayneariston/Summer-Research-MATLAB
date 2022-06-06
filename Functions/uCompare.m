function [mu, sigma, allzero] = uCompare(u,ucalc,lamb,fast)
    allzero = "";
    [h,l,~] = size(u);
    z = 2.58; % to reduce the influence of edges with padded zeros in the mean difference
    z = ceil(z/lamb);
    if nargin>3
        if fast
            diffmag = sqrt((u(z:h-z,z:l-z,1)-ucalc(:,:,1)).^2+(u(z:h-z,z:l-z,2)-ucalc(:,:,2)).^2);
            umag = sqrt((u(z:h-z,z:l-z,1)).^2+(u(z:h-z,z:l-z,2)).^2);
        else
            error("What am I supposed to do? -uCompare()");
        end
    else
        diffmag = sqrt((u(z:h-z,z:l-z,1)-ucalc(z:h-z,z:l-z,1)).^2+(u(z:h-z,z:l-z,2)-ucalc(z:h-z,z:l-z,2)).^2);
        umag = sqrt((u(z:h-z,z:l-z,1)).^2+(u(z:h-z,z:l-z,2)).^2);
    end
    rel = diffmag./umag;
    rel(isinf(rel)) = nan;
    mu = mean(rel,"all","omitnan");
    sigma = std(rel,1,"all","omitnan");
    if all(isnan(mu))
        allzero = "WARNING! All zero";
        mu = mean(diffmag,"all");
        sigma = std(diffmag,1,"all");
    end
end