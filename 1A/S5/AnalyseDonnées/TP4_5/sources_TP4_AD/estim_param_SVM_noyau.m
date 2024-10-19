% fonction estim_param_SVM_noyau (pour l'exercice 2)

function [X_VS,Y_VS,Alpha_VS,c,code_retour] = estim_param_SVM_noyau(X,Y,sigma)

Aeq = Y';
F = -ones(size(Y));
beq = 0;
lb = zeros(size(Y));

K=zeros(size(Y));
for i = 1: length(Y)
    for j = 1 : length(Y)
        K(i,j)= exp(-(norm(X(i,:)-X(j,:))*norm(X(i,:)-X(j,:)))/2*sigma*sigma);
    end
end

H = diag(Y)*K*diag(Y);
[Alpha, ~, code_retour] = quadprog(H,F,[],[], Aeq, beq, lb, []);
emplacement_X_VS = (Alpha > 1e-6);
X_VS = X(emplacement_X_VS, :);
Y_VS = Y(emplacement_X_VS);
Alpha_VS = Alpha(emplacement_X_VS);
% w = X_VS'*diag(Y_VS)*Alpha_VS;
X_VS_plus_1 = X_VS(Y_VS == 1, :);
Y_VS_plus_1 = Y_VS(Y_VS == 1);
emplacement = find(emplacement_X_VS == 1);
c = -  Y_VS_plus_1(1);
for j=1:length(Y)
    c = c+Alpha_VS*Y_VS(j)*K(j,emplacement(1));
end

end
