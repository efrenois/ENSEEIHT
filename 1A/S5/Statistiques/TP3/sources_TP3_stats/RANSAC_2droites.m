% Fonction RANSAC_2droites (exercice_2.m)

function [rho_F_estime,theta_F_estime] = RANSAC_2droites(rho,theta,parametres)

    % Parametres de l'algorithme RANSAC :
    S_ecart = parametres(1); % seuil pour l'ecart
    S_prop = parametres(2); % seuil pour la proportion
    k_max = parametres(3); % nombre d'iterations
    n_donnees = length(rho);
    ecart_moyen_min = Inf;

    for k=1:k_max

        indice = randperm(n_donnees,2);
        [ rho_F,theta_F, ~] = estim_param_F(rho(indice),theta(indice));
        vect_binaire = (abs(rho-rho_F*cos(theta-theta_F)) <= S_ecart);
        proportion_donnees_conformes = mean(vect_binaire);

        if  proportion_donnees_conformes >= S_prop
            [rho2F,theta2F,ecart_moyen_courant] = estim_param_F(rho(vect_binaire),theta(vect_binaire));
            if ecart_moyen_courant <= ecart_moyen_min
                ecart_moyen_min = ecart_moyen_courant;
                rho_F_estime = rho2F;
                theta_F_estime = theta2F;
            end
        end
    end 
end