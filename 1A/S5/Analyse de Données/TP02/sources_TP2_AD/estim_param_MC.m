% fonction estim_param_MC (pour exercice_1.m)

function parametres = estim_param_MC(d,x,y)
A=zeros(length(x),d);
B = y-y(1)*vecteur_bernstein(x,d,0);
for i=1:d
    A(:,i)= vecteur_bernstein(x,d,i);
end
parametres = A\B;
end
