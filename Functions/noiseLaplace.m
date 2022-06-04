function p = noiseLaplace(ny,nx,a)
    % Solving the 2-D Laplace's equation by the Finite Difference
    ...Method 
    % Numerical scheme used is a second order central difference in space
    ...(5-point difference)

    %Specifying parameters
%     nx=60;                           %Number of steps in space(x)
%     ny=60;                           %Number of steps in space(y)       
    niter=1000*a/16;                    %Number of iterations % I tried the reasonable value wrt the atom diameter
    x = 1:nx;
    y = 1:ny;

    %Initial Conditions
    p=randn(ny,nx);

    %Boundary conditions
%     p(:,1)=0;
%     p(:,nx)=0;
%     p(1,:)=0;                   
%     p(ny,:)=0;               

    %Explicit iterative scheme with C.D in space (5-point difference)
    j=2:nx-1;
    i=2:ny-1;
    for it=1:niter
        pn=p;
        
        % middle
        p(i,j) = (pn(i+1,j)+pn(i-1,j)+pn(i,j+1)+pn(i,j-1))/4;
        
        % edges
        p(i,1) = (pn(i+1,1)+pn(i-1,1)+pn(i,2))/3;
        p(i,nx) = (pn(i+1,nx)+pn(i-1,nx)+pn(i,nx-1))/3;
        p(1,j) = (pn(2,j)+pn(1,j+1)+pn(1,j-1))/3;
        p(ny,j) = (pn(ny-1,j)+pn(ny,j+1)+pn(ny,j-1))/3;

        % corners
        p(1,1) = (pn(1,2)+pn(2,1))/2;
        p(1,nx) = (pn(1,nx-1)+pn(2,nx))/2;
        p(ny,1) = (pn(ny-1,2)+pn(ny,2))/2;
        p(ny,nx) = (pn(ny-1,nx)+pn(ny,nx-1))/2;
    end
    
    p = (p-mean(p,"all"))/std(p,1,"all");
    
    noisePlot(ny,nx,p,it);
end