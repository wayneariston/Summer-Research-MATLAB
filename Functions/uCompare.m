function [mu, sigma, allzero] = uCompare(u,ucalc,lamb)
    allzero = "";
    [h,l,~] = size(u);
    z = 2.58; % to reduce the influence of edges with padded zeros in the mean difference
    z = ceil(z/lamb);
    diffmag = sqrt((u(z:h-z,z:l-z,1)-ucalc(z:h-z,z:l-z,1)).^2+(u(z:h-z,z:l-z,2)-ucalc(z:h-z,z:l-z,2)).^2);
    umag = sqrt((u(z:h-z,z:l-z,1)).^2+(u(z:h-z,z:l-z,2)).^2);
    rel = diffmag./umag;
    rel(isinf(rel)) = nan;
    mu = mean(rel,"all","omitnan");
    sigma = std(rel,1,"all","omitnan");
    if isnan(mu)
        allzero = "WARNING! All zero";
        mu = mean(diffmag,"all");
    end
end