% fonction moyenne_normalisee_3v (pour l'exercice 1bis)

function x = moyenne_normalisee_3v(I)

centre = [round(size(I,1)/2) round(size(I,1)/2)];
delta = round(0.1*centre);
V = I((centre(1)-delta(1)):(centre(1)+delta(1)),(centre(2)-delta(2)):(centre(2)+delta(2)));

% Conversion en flottants :
V = single(V);

% Calcul des couleurs normalisees :
somme_canaux = max(1,sum(V,3));
r = V(:,:,1)./somme_canaux;
v = V(:,:,2)./somme_canaux;

    
% Calcul des couleurs moyennes :
r_barre = mean(r(:));
v_barre = mean(v(:));
x = [r_barre v_barre];


end
