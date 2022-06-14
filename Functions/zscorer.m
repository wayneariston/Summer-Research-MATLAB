function z = zscorer(p)
    % to return the z score given the proportion under the 2d symmetric Gaussian surface
    z = sqrt(-2*log(1-p));
end