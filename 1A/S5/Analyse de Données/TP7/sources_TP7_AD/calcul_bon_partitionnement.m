% fonction calcul_bon_partitionnement (pour l'exercice 1)

function meilleur_pourcentage_partitionnement = calcul_bon_partitionnement(Y_pred,Y)

P = perms([1 2 3]);
score = zeros(size(P,1),1);
for i=1:size(P,1)
    Y_pred_permute = Y_pred;
    for j = 1:size(P,2)
        Y_pred_permute(Y_pred_permute==j) = P(i,j);
    end 
    score(i) = sum(Y_pred_permute == Y)/length(Y);
end
meilleur_pourcentage_partitionnement = 100*max(score);

end