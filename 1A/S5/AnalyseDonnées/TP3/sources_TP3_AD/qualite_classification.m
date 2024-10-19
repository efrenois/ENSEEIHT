% fonction qualite_classification (pour l'exercice 2)

function [pourcentage_bonnes_classifications_total,pourcentage_bonnes_classifications_fibrome, ...
          pourcentage_bonnes_classifications_melanome] = qualite_classification(Y_pred,Y)

bonnes_classifications_fibrome =0;
bonnes_classifications_melanome =0;

for i=1:length(Y)
    if Y_pred(i) == Y(i) && Y(i)==1
        bonnes_classifications_fibrome = bonnes_classifications_fibrome +1 ;
    end
    if Y_pred(i) == Y(i) && Y(i)==2
        bonnes_classifications_melanome = bonnes_classifications_melanome + 1;
    end   
    
    pourcentage_bonnes_classifications_fibrome = (bonnes_classifications_fibrome/length(find(Y==1)))*100;
    pourcentage_bonnes_classifications_melanome = (bonnes_classifications_melanome/length(find(Y==1)))*100;
    pourcentage_bonnes_classifications_total = pourcentage_bonnes_classifications_fibrome + pourcentage_bonnes_classifications_melanome;

end