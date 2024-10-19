% function ACP (pour exercice_2.m)

function [C,bornes_C,coefficients_RVG2gris] = ACP(X)

X_centree = X - mean(X);
Sigma = (1/size(X,1))*X_centree'*X_centree;
[W,D] = eig(Sigma);        % W=vexteurs propres D=valeurs propres
valeurs_propres = diag(D);
[valeurs_propres_triees, ordre] = sort(valeurs_propres,'descend');
W_triee = W(:,ordre);
C = X*W_triee;

bornes_C = [min(C(:)), max(C(:))];
coefficients_RVG2gris = W_triee(:,1)./sum(W_triee(:,1));
    
end
