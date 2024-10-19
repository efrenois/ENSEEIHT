function L = laplacian(nu,dx1,dx2,N1,N2)
%
%  Cette fonction construit la matrice de l'opérateur Laplacien 2D anisotrope
%
%  Inputs
%  ------
%
%  nu : nu=[nu1;nu2], coefficients de diffusivité dans les dierctions x1 et x2. 
%
%  dx1 : pas d'espace dans la direction x1.
%
%  dx2 : pas d'espace dans la direction x2.
%
%  N1 : nombre de points de grille dans la direction x1.
%
%  N2 : nombre de points de grilles dans la direction x2.
%
%  Outputs:
%  -------
%
%  L      : Matrice de l'opérateur Laplacien (dimension N1N2 x N1N2)
%
% 

% Initialisation
L=sparse([]);
e = ones(N1*N2,1);
A = spdiags([e*(-nu(1)/(dx1*dx1)) e*(-nu(2)/(dx2*dx2)) e*(2*((nu(1)/(dx1*dx1))+(nu(2)/(dx2*dx2)))) e*(-nu(2)/(dx2*dx2)) e*(-nu(1)/(dx1*dx1)) ] , [-N2-1 -1 0 1 N2+1], N1*N2, N1*N2);
L=A;
end    
