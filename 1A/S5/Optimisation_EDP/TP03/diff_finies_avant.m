% Auteur : J. Gergaud
% décembre 2017
% -----------------------------
% 



function Jac = diff_finies_avant(fun,x,option)
%
% Cette fonction calcule les différences finies avant sur un schéma
% Paramètres en entrées
% fun : fonction dont on cherche à calculer la matrice jacobienne
%       fonction de IR^n à valeurs dans IR^m
% x   : point où l'on veut calculer la matrice jacobienne
% option : précision du calcul de fun (ndigits)
%
% Paramètre en sortie
% Jac : Matrice jacobienne approximé par les différences finies
%        real(m,n)
% ------------------------------------
m = size(x,1);
n = size(fun(x),1);
Jac = zeros(m,n);
v= zeros(1,n);
w = max(eps,10^(-option));
for i = 1:m
    v(i) = 1;
    h(i)= sqrt(w)*max(norm(x(i)),1)*sgn(x(i));
    Jac(:,i)= (fun(x+h(i)*v)-fun(x))/h;
    v(i) = 0;
end
end 

function s = sgn(x)
% fonction signe qui renvoie 1 si x = 0
if x==0
  s = 1;
else 
  s = sign(x);
end
end







