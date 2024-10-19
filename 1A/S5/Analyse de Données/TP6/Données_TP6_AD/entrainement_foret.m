% fonction entrainement_foret (pour l'exercice 2)

function foret = entrainement_foret(X,Y,nb_arbres,proportion_individus)
nb_individus = round(proportion_individus*length(Y));
nb_variables_par_split = round(sqrt(size(X,2)));
foret = cell(1,nb_arbres);

for i=1:nb_arbres
    indice_alea = randperm(length(Y));
    X_a = X(indice_alea,:);
    Y_a = Y(indice_alea);
    foret{i} = fitctree(X_a,Y_a,'NumVariablesToSample',nb_variables_par_split);        
end
