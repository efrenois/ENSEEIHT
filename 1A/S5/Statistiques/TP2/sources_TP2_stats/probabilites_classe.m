% Fonction probabilites_classe (exercice_3.m)

function [probas_classe_1,probas_classe_2] = probabilites_classe(x_donnees_bruitees,y_donnees_bruitees,sigma,...
                                                                 a_1,b_1,proportion_1,a_2,b_2,proportion_2)

probas_classe_1 = proportion_1*exp(((y_donnees_bruitees-a_1*x_donnees_bruitees-b_1)^2)/(-1/2)*sigma^2);
probas_classe_2 = proportion_2*exp(((y_donnees_bruitees-a_2*x_donnees_bruitees-b_2)^2)/(-1/2)*sigma^2);

end