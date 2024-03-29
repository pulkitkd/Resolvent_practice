function [u, s, v] = getResolventSVD(kx, kz, omega, Re, N, Nsvd, U0)

%% create the LNS operators

[L, M] = LNS_operators(kx, kz, N, Re, U0);

LHS = (L - 1i*omega*M);
RHS = M;

%% apply BCs
% no slip boundary conditions
% no condition for pressure
LHS(1,:)     = 0;
LHS(N,:)     = 0;
LHS(N+1, :)  = 0;
LHS(2*N,:)   = 0;
LHS(2*N+1,:) = 0;
LHS(3*N,:)   = 0;


LHS(1,1)         = 1;
LHS(N,N)         = 1;
LHS(N+1,N+1)     = 1;
LHS(2*N,2*N)     = 1;
LHS(2*N+1,2*N+1) = 1;
LHS(3*N,3*N)     = 1;


RHS(1,:)     = 0;
RHS(N,:)     = 0;
RHS(N+1,:)   = 0;
RHS(2*N,:)   = 0;
RHS(2*N+1,:) = 0;
RHS(3*N,:)   = 0;

%% create the resolvent operator

H = LHS\RHS;

%% scale it

[W, iW] = weight_matrix(N);
Hs = W*H*iW;
Hs = Hs(1:3*N,1:3*N);

%% take the SVD of the scaled resolvent

% [su, s, sv] = svds(Hs, Nsvd);
[su, s, sv, flag] = svds(Hs, Nsvd, 'largest', 'SubspaceDimension', 60);
s = diag(s);
u = iW(1:3*N,1:3*N)*su;
v = iW(1:3*N,1:3*N)*sv;

% disp("Checking if reduced H is justified")
% norm(H(1:3*N,1:3*N) - u*diag(s)*v'*(W(1:3*N,1:3*N)'*W(1:3*N,1:3*N)))
% norm(Hs - su*diag(s)*sv')
if(flag == 1)
    disp("Error. SVD did not converge. Singular modes/values may be wrong!")
end
% imagesc(imag(Hs))
% colorbar('eastoutside')
end
