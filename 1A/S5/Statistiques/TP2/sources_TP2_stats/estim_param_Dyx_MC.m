% Fonction estim_param_Dyx_MC (exercice_1.m)

function [a_Dyx,b_Dyx] = ...
                   estim_param_Dyx_MC(x_donnees_bruitees,y_donnees_bruitees)

[x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);

A = [x_donnees_bruitees ones(length(x_donnees_bruitees))];
B = y_donnees_bruitees;

X = A\B;
a_Dyx = X(1);
b_Dyx = X(2);
R = 1 - (sum((y_donnees_bruitees-a_Dyx*x_donnees_bruitees-b_Dyx).*(y_donnees_bruitees-a_Dyx*x_donnees_bruitees-b_Dyx))/(sum((y_donnees_bruitees-y_G).*(y_donnees_bruitees-y_G))));
coeff_R2 = sqrt(R);   
    
end