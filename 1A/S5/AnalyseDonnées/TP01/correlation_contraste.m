% function correlation_contraste (pour exercice_1.m)

function [correlation,contraste] = correlation_contraste(X)

X_centree = X - mean(X);
Sigma = (1/size(X,1))*X_centree'*X_centree;

R_rv = Sigma(2,1)/(sqrt(Sigma(1,1))*sqrt(Sigma(2,2)));
R_rb = Sigma(1,3)/(sqrt(Sigma(1,1))*sqrt(Sigma(3,3)));
R_vb = Sigma(2,3)/(sqrt(Sigma(2,2))*sqrt(Sigma(3,3)))
correlation = [R_rv R_rb R_vb];

Cr = Sigma(1,1)/(Sigma(1,1)+Sigma(2,2)+Sigma(3,3));
Cv = Sigma(2,2)/(Sigma(1,1)+Sigma(2,2)+Sigma(3,3));
Cb = Sigma(3,3)/(Sigma(1,1)+Sigma(2,2)+Sigma(3,3));
contraste = [Cr Cv Cb];
end
