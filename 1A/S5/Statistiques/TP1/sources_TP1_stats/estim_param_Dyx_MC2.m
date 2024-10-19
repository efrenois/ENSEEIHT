% Fonction estim_param_Dyx_MC2 (exercice_2bis.m)

function [a_Dyx,b_Dyx,coeff_r2] = ...
                   estim_param_Dyx_MC2(x_donnees_bruitees,y_donnees_bruitees)

x_G = mean(x_donnees_bruitees);
y_G = mean(y_donnees_bruitees);
Esp_X = mean(x_donnees_bruitees);
Esp_Y = mean(y_donnees_bruitees);
Esp_XY = mean(x_donnees_bruitees.*y_donnees_bruitees);
Cov_XY = Esp_XY-Esp_X*Esp_Y;
Var_X = mean(x_donnees_bruitees.*x_donnees_bruitees)-Esp_X*Esp_X;
Var_Y = mean(y_donnees_bruitees.*y_donnees_bruitees)-Esp_Y*Esp_Y;
r = Cov_XY/sqrt(Var_X*Var_Y);
coeff_r2 = r*r;

a_Dyx = r*sqrt(Var_Y/Var_X);
b_Dyx = y_G-a_Dyx*x_G;
    
end