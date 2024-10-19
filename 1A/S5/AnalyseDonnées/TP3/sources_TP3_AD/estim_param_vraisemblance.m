% fonction estim_param_vraisemblance (pour l'exercice 1)

function [mu,Sigma] = estim_param_vraisemblance(X)

X_centree = X - mean(X);
Sigma = (1/size(X,1))*X_centree'*X_centree;
mu=mean(X);
   

end