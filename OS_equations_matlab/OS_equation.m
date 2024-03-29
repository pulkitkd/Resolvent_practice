%% Eigenvalues of the Orr-Sommerfeld operator

%% Parameters
R = 5000;
kx = 1;
kz = 0;
N = 500;

%% Differentiation matrices
[x,DM] = chebdif(N,2); 
D1 = DM(:,:,1); % first derivative
D2 = DM(:,:,2); % second derivative

[~,D4] = cheb4c(N); % fourth derivative; incorporates clamped boundary conditions

%% Mean velocity
U = diag(1-x.^2);

%% Boundary conditions
%  dropping leading rows and columns from D1, D2
%  D4 already incorporates this along with a change of basis functions
D1 = D1(2:N-1,2:N-1);
D2 = D2(2:N-1,2:N-1);

U = U(2:N-1,2:N-1);
Uyy = diag(D2*diag(U));

%% Create the OS operators
ksq = kx*kx + kz*kz;
I = eye(N-2);

% Trefethen's operators for U = 1-x^2 and k = kx = 1
% A = (D4-2*D2+I)/R - 2i*I - 1i*diag(1-x(2:N-1).^2)*(D2-I);
% B = D2-I;

A = 1j*kx*U*(D2 - ksq*I) - 1j*kx*Uyy - (D4 + ksq*ksq*I - 2*ksq*D2)/R;
B = 1j*(D2 - ksq*I);

%% Solve the eigenvalue problem and plot it
[V,ee] = eig(A,B);
% plot the eigenvalues
ee = diag(ee);
ee = sort(ee);
plot(ee(1:50),'.','markersize',12)
axis([0 1 -1 0]);
% plot the eigenvectors
% grid on
% axis square
% axis([0 1 -1 0])
% plot(x(2:N-1),imag(V(:,N-2)))

