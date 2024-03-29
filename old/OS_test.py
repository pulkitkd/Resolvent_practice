import numpy as np
from scipy.linalg import eig

import matplotlib.pyplot as plt
from numpy import pi, cos, sin, diag

from cheb_trefethen import *
##############################
"Define the inputs"
Re = 10000.
Reinv = 1./Re
# N = 10
Ny = 128
kx = 1.
kz = 0.
n = Ny+1

ksq = kx*kx + kz*kz
Idn = eye(n)
D, y = cheb(Ny)
u = (1. - y*y)
uy = D @ u
uyy = D @ D @ u 
U = diag(1. - y*y)

DU = diag(D@u)
D2 = D@D
D2U = diag(D2@u)
D4 = D2@D2

Los = 1j*kx*diag(u)@(ksq*Idn - D2) + 1j*kx*diag(uyy) + Reinv*(D4 - 2*ksq*D2 + ksq*ksq*Idn)
Lsq = 1j*kx*diag(u) + Reinv*(ksq*Idn - D2)
L = np.block([[Los, np.zeros((n, n))],[1j*kz*diag(uy), Lsq]])

M = np.block([[(ksq*Idn - D2), np.zeros((n, n))], [np.zeros((n, n)), Idn ]])

"""
BC for O-S test
v = dv/dy = eta = 0 at walls
"""
L[0, :] = 0.
L[n-1, :] = 0.
L[0, 0] = 1.
L[n-1, n-1] = 1.

L[n, :] = 0.
L[2*n-1, :] = 0.
L[n, n] = 1.
L[2*n-1, 2*n-1] = 1.

L[1, :] = 0.
L[n-2, :] = 0.
L[1, 0:n] = D[0, :]
L[n-2, 0:n] = D[n-1, :]

M[0, :] = 0.
M[1, :] = 0.

M[n-1, :] = 0.
M[n-2, :] = 0.

M[n, :] = 0.
M[2*n-1, :] = 0.
#############################
w, v = eig(L, b=M, check_finite=True)
# wreal = np.real(w)
# wimag = np.imag(w)
w = -1j*w
w = np.sort(w)
print("Eigenvalues = ", w)
#############################
plt.scatter(np.real(w), np.imag(w))
plt.xlim((0,1))
plt.ylim((-1,0.2))
plt.xlabel("real")
plt.ylabel("imag")
plt.grid()
plt.show()
#############################