% Fonction RANSAC_3points (exercice_3)

function [C_estime,R_estime] = RANSAC_3points(x_donnees_bruitees,y_donnees_bruitees,parametres)

    % Parametres de l'algorithme RANSAC :
    S_ecart = parametres(1); % seuil pour l'ecart
    S_prop = parametres(2); % seuil pour la proportion
    k_max = parametres(3); % nombre d'iterations
    n_tirages = parametres(4); 
    n_donnees = size(x_donnees_bruitees,1);
    ecart_moyen_min = Inf;

end