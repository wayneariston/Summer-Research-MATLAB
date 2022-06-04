function noisePlot(h,l,z,it,maxf)
    x = 1:l;
    y = 1:h;
    surf(x,y,z,'EdgeColor','none');       
    shading interp
    if nargin<5
        title({'Simulated physical distortion by Laplace''s equation';['{\itNumber of iterations} = ',num2str(it)]})
    else
        maxf = max(h,l)/(maxf/2);
        title({'Simulated physical distortion after low-pass filter';['{\itMaximum frequency} = ',num2str(maxf)]})
    end
    xlabel('$x$ [pixel]',"Interpreter","latex")
    ylabel('$y$ [pixel]',"Interpreter","latex")
    zlabel('$\Delta$intensity',"Interpreter","latex")
    set(gca,"YDir","reverse")
    colormap jet;
    colorbar("Location","southoutside")
    axis equal tight
end