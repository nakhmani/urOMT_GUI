function [vi,ind] = interp_vel(V,n,s1,s2,s3,h)
%% returns interpolated velocity value v1 = V(s1,s2,s3)
% where s1 = row index, s2 = col index, s3 = depth index
% interp_vel(u,n,xi,xj,xk) == [interp3(par.Yc,par.Xc,par.Zc,ux,xj,xi,xk),interp3(par.Yc,par.Xc,par.Zc,uy,xj,xi,xk),interp3(par.Yc,par.Xc,par.Zc,uz,xj,xi,xk)]
% where u = [ux(:),uy(:),uz(:)]

if nargin < 6
    h     = [1,1,1];
end

[n1,n2,n3]=deal(n(1),n(2),n(3));

% convert starting points (s1,s2,s3) from cell-centered grid [0,
% n1*h(1)]x[0, n2*h(2)]x[0, n3*h(3)] to starting points (sX,sY,sZ) in
% MATLAB matrix coord sys [1, n1]x[1, n2]x[1, n3]
sX = s1./h(1) + 0.5;
sY = s2./h(2) + 0.5;
sZ = s3./h(3) + 0.5;

i = floor(sX);
j = floor(sY);
k = floor(sZ);

xi = sX - i;
eta = sY - j;
zeta = sZ - k;

ind = find(1 <= i & i < n1 & 1 <= j & j < n2 & 1 <= k & k < n3);
if length(ind)<length(sX)
    warning('velInterp:pointOutOfBounds','interp_vel.m >>> %d points out of bounds, cannot find interpolated velocity vector field at such points',length(sX)-length(ind))
end

%vi = zeros(length(ind),3);

%get lin indeces of 8 points surrounding (sX,sY,sZ):
ijk    = i(ind) + (j(ind)-1)*n1 + (k(ind)-1)*n1*n2;     %p1
i1jk   = i(ind) + 1 + (j(ind)-1)*n1 + (k(ind)-1)*n1*n2; %p2
ij1k   = i(ind) + j(ind)*n1 + (k(ind)-1)*n1*n2;         %p3
i1j1k  = i(ind) + 1 + j(ind)*n1 + (k(ind)-1)*n1*n2;     %p4
ijk1   = i(ind) + (j(ind)-1)*n1 + k(ind)*n1*n2;         %p5
i1jk1  = i(ind) + 1 + (j(ind)-1)*n1 + k(ind)*n1*n2;     %p6
ij1k1  = i(ind) + j(ind)*n1 + k(ind)*n1*n2;             %p7
i1j1k1 = i(ind) + 1 + j(ind)*n1 + k(ind)*n1*n2;         %p8

vi = ((V(ijk,:).*(1-xi(ind)) + V(i1jk,:).*xi(ind)).*(1-eta(ind)) + ...
    (V(ij1k,:).*(1-xi(ind)) + V(i1j1k,:).*xi(ind)).*eta(ind)).*(1-zeta(ind)) + ...
    ((V(ijk1,:).*(1-xi(ind)) + V(i1jk1,:).*xi(ind)).*(1-eta(ind)) + ...
    (V(ij1k1,:).*(1-xi(ind)) + V(i1j1k1,:).*xi(ind)).*eta(ind)).*zeta(ind);
end
