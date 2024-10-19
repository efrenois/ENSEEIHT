% Fonction estim_param_F (exercice_1.m)

function [rho_F,theta_F,ecart_moyen] = estim_param_F(rho,theta)

A = [cos(theta) sin(theta)];
B = rho; 

X = A\B; 

x_f = X(1);
y_f = X(2);

rho_F = sqrt(x_f*x_f + y_f*y_f);
theta_F = atan2(y_f ,x_f);

ecart_moyen = mean(abs(A*X-B));


end