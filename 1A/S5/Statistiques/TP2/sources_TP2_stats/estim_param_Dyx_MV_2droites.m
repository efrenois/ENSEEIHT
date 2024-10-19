% Fonction estim_param_Dyx_MV_2droites (exercice_2.m) 

function [a_Dyx_1,b_Dyx_1,a_Dyx_2,b_Dyx_2] = ... 
         estim_param_Dyx_MV_2droites(x_donnees_bruitees,y_donnees_bruitees,sigma, ...
                                     tirages_G_1,tirages_psi_1,tirages_G_2,tirages_psi_2)    

residus_Y1 = (repmat(y_donnees_bruitees',length(tirages_psi_1),1)-repmat(tirages_G_1(2),1,length(y_donnees_bruitees)));
residus_X1 = (repmat(x_donnees_bruitees',length(tirages_psi_1),1)-repmat(tirages_G_1(1),1,length(y_donnees_bruitees)));
vecteurtanpsi1 = tan(tirages_psi_1);
residus1 = residus_Y1-vecteurtanpsi1'.*residus_X1;

residus_Y2 = (repmat(y_donnees_bruitees',length(tirages_psi_2),1)-repmat(tirages_G_2(2),1,length(y_donnees_bruitees)));
residus_X2 = (repmat(x_donnees_bruitees',length(tirages_psi_2),1)-repmat(tirages_G_2(1),1,length(y_donnees_bruitees)));
vecteurtanpsi2 = tan(tirages_psi_2);
residus2 = residus_Y2-vecteurtanpsi2'.*residus_X2;

A = log(exp((residus1.*residus1)/((-1/2)*sigma^2))+exp((residus2.*residus2)/((-1/2)*sigma^2)));
B=sum(A);

[~, indice] = max(B);

a_Dyx_1 = tan(tirages_psi_1(indice));
b_Dyx_1 = tirages_G_1(indice,2)-a_Dyx_1*tirages_G_1(indice,1);

a_Dyx_2 = tan(tirages_psi_2(indice));
b_Dyx_2 = tirages_G_2(indice,2)-a_Dyx_2*tirages_G_2(indice,1);

end