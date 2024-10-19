clear all;
close all;

% Chargement données
data_type1 = fscanf(fopen('spectre_size200_type1.txt'),'%f');
data_type2 = fscanf(fopen('spectre_size200_type2.txt'),'%f');
data_type3 = fscanf(fopen('spectre_size200_type3.txt'),'%f');
data_type4 = fscanf(fopen('spectre_size200_type4.txt'),'%f');

% Tracé de la figure comparative 
% Création de la figure
figure

% Tracé du premier graphique
subplot(2,2,1)
plot(data_type1,'b')
ylabel('Eigenvalues')
legend('Type 1')
title('Eigenvalue distribution for a dimension of 200');

% Tracé du deuxième graphique
subplot(2,2,2)
plot(data_type2,'r')
ylabel('Eigenvalues')
legend('Type 2')
title('Eigenvalue distribution for a dimension of 200');

% Tracé du troisième graphique
subplot(2,2,3)
plot(data_type3,'g')
ylabel('Eigenvalues')
legend('Type 3')
title('Eigenvalue distribution for a dimension of 200');

% Tracé du quatrième graphique
subplot(2,2,4)
plot(data_type4,'y')
ylabel('Eigenvalues')
legend('Type 4')
title('Eigenvalue distribution for a dimension of 200');
