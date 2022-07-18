function [mu, sigma] = uCompare(u1,u2,lamb,z,fast)
    arguments
        u1; u2; lamb; z = 2.58;
        fast = false;

    end
    [h,l,d] = size(u1);
    z = ceil(z/lamb);

    if all(size(u1)==size(u2))
        if d==2
            if fast
                diffmag = sqrt((u1(1+z:h-z,1+z:l-z,1)-u2(:,:,1)).^2+(u1(1+z:h-z,1+z:l-z,2)-u2(:,:,2)).^2);
                u1mag = sqrt((u1(z:h-z,z:l-z,1)).^2+(u1(z:h-z,z:l-z,2)).^2);
            else
                diffmag = sqrt((u1(1+z:h-z,1+z:l-z,1)-u2(1+z:h-z,1+z:l-z,1)).^2+(u1(1+z:h-z,1+z:l-z,2)-u2(1+z:h-z,1+z:l-z,2)).^2);
                u1mag = sqrt((u1(1+z:h-z,1+z:l-z,1)).^2+(u1(1+z:h-z,1+z:l-z,2)).^2);
            end
        elseif d==1
                diffmag = u1(1+z:h-z,1+z:l-z)+u2(1+z:h-z,1+z:l-z);
                u1mag = 2;
        end
        rel = diffmag./u1mag;
        rel(isinf(rel)) = nan;
        mu = mean(rel,"all","omitnan");
        sigma = std(rel,1,"all","omitnan");
        if all(isnan(mu))
            warning("All magnitudes of u are zero. Taking absolute error.");
            mu = mean(diffmag,"all");
            sigma = std(diffmag,1,"all");
        end
    elseif all(size(u1)-size(u2)==1)
        ui1 = u1(1+z:h-z-1,1+z:l-z-1);
        ui2 = u2(1+z:h-z-1,1+z:l-z-1);
        ui1 = (ui1-mean(ui1,"all"))./std(ui1,0,"all");
        ui2 = (ui2-mean(ui2,"all"))./std(ui2,0,"all");
        mu = sum(ui1.*ui2,"all")/(numel(ui2)-1);
    else
        error("Vector/scalar field dimensions mismatch.");
    end
end