from cheb_trefethen import  *

def noSlipBC(M, L, n, a=50):
    
    D, x = cheb(n-1);
    
    L[0, :] = 0.
    L[0, 0] = 1.
    L[n-1, :] = 0.
    L[n-1, n-1] = 1.

    M[0, :] = 0.
    M[0, 0] = a
    M[n-1, :] = 0.
    M[n-1, n-1] = a

    # eta^ = 0
    L[n, :] = 0.
    L[2*n-1, :] = 0.
    L[n, n] = 1.
    L[2*n-1, 2*n-1] = 1.

    M[n, :] = 0.
    M[n, n] = a
    M[2*n-1, :] = 0.
    M[2*n-1, 2*n-1] = a

    # dv^ / dy = 0
    L[1, :] = 0.
    L[n-2, :] = 0.
    L[1, 0:n] = a*D[0, :]
    L[n-2, 0:n] = a*D[n-1, :]

    M[1, :] = 0.
    M[n-2, :] = 0.
    M[1, 0:n] = D[0, :]
    M[n-2, 0:n] = D[n-1, :]
    
    return M, L
