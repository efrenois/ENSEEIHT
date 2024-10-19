% fonction classification_SVM_avec_noyau (pour l'exercice 2)

function Y_pred = classification_SVM_avec_noyau(X,sigma,X_VS,Y_VS,Alpha_VS,c)

K=zeros(size(Y));
for i = 1: length(Y)
    for j = 1 : length(Y)
        K(i,j)= exp(-(norm(X(i,:)-X(j,:))*norm(X(i,:)-X(j,:)))/2*sigma*sigma);
    end
end

Y_pred =  sign();

end