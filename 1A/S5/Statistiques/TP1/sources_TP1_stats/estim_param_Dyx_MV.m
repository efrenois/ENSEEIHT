% Fonction estim_param_Dyx_MV (exercice_1.m)

function [a_Dyx,b_Dyx,residus_Dyx] = ...
           estim_param_Dyx_MV(x_donnees_bruitees,y_donnees_bruitees,tirages_psi)

[x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);

R = y_donnees_bruitees_centrees-x_donnees_bruitees_centrees*tan(tirages_psi);

sigma = sum(R.*R);

[~, indice] = min(sigma);

a_Dyx = tan(tirages_psi(indice));

b_Dyx = y_G-a_Dyx*x_G;

residus_Dyx = R(:,indice);
    
end