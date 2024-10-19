% fonction classification_MV (pour l'exercice 2)

function Y_pred_MV = classification_MV(X,mu_1,Sigma_1,mu_2,Sigma_2)

modele_V1 = modelisation_vraisemblance(X,mu_1,Sigma_1);
modele_V2 = modelisation_vraisemblance(X,mu_2,Sigma_2);
Y_pred_MV = zeros(length(X),1);

for i=1:length(X)
    if modele_V1(i)>modele_V2(i)
        Y_pred_MV(i)=1;
    else
       Y_pred_MV(i)=2;
    end     
end
