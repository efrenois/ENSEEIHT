% fonction classification_MAP (pour l'exercice 3)

function Y_pred_MAP = classification_MAP(X,p1,mu_1,Sigma_1,mu_2,Sigma_2)

modele_V1 = modelisation_vraisemblance(X,mu_1,Sigma_1);
modele_V2 = modelisation_vraisemblance(X,mu_2,Sigma_2);
Y_pred_MAP = zeros(length(X),1);
MAP1 = modele_V1*p1;
MAP2 = modele_V2*(1-p1);

for i=1:length(X)
    if MAP1(i)>MAP2(i)
        Y_pred_MAP(i)=1;
    else
       Y_pred_MAP(i)=2;
    end     
end

    
end
