function [y,p] = tauchen(rho,sigma,M,q)
% -------------------------------------------------
% - Inputs:
%     - rho: AR(1) persistence parameter
%     - sigma: AR(1) innovation standard deviation
%     - M: number of grid points
%     - q: boundary parameter (optional, default=3)
% - Output: 
%     - y: discretized state space
%     - p: transition matrix
% -------------------------------------------------

    if nargin<4
        q = 3;
    end
    
    y(M) = q*(sigma^2/(1-rho^2))^0.5;
    y(1) = -y(M);
    y = linspace(y(1),y(M),M);
    w = y(2)-y(1);
    
    for i=1:M
        for j=1:M
            if j==1
                p(i,j) = normcdf((y(j)+w/2-rho*y(i))/sigma);
            elseif j==M
                p(i,j) = 1-normcdf((y(j)-w/2-rho*y(i))/sigma);
            else
                p(i,j) = normcdf((y(j)+w/2-rho*y(i))/sigma) - ...
                         normcdf((y(j)-w/2-rho*y(i))/sigma);
            end
        end
    end
end