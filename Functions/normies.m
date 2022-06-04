function A = normies(A, lim)
    % I'm creating this function cuz MATLAB's normalize() is dumb
    if nargin<2
        lim = [-1 1];
    end
    A = lim(1)+(A-min(A,[],"all"))./(max(A,[],"all")-min(A,[],"all")).*(lim(2)-lim(1));
end