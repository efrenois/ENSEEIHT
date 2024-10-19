%%  Application de la SVD : compression d'images

clear all
close all

% Lecture de l'image
I = imread('BD_Asterix_1.png');
I = rgb2gray(I);
I = double(I);

[q, p] = size(I)

% Décomposition par SVD
fprintf('Décomposition en valeurs singulières\n')
tic
[U, S, V] = svd(I);
toc

l = min(p,q);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% On choisit de ne considérer que 200 vecteurs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% vecteur pour stocker la différence entre l'image et l'image reconstuite
inter = 1:40:(200+40);
inter(end) = 200;
differenceSVD = zeros(size(inter,2), 1);

% images reconstruites en utilisant de 1 à 200 vecteurs (avec un pas de 40)
ti = 0;
td = 0;
for k = inter

    % Calcul de l'image de rang k
    Im_k = U(:, 1:k)*S(1:k, 1:k)*V(:, 1:k)';

    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
    imagesc(Im_k), axis equal
    
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD(td) = sqrt(sum(sum((I-Im_k).^2)));
    % pause
end

% Figure des différences entre image réelle et image reconstruite
ti = ti+1;
figure(ti)
hold on 
plot(inter, differenceSVD, 'rx')
ylabel('RMSE')
xlabel('rank k')
pause


% Plugger les différentes méthodes : eig, puissance itérée et les 4 versions de la "subspace iteration method" 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QUELQUES VALEURS PAR DÉFAUT DE PARAMÈTRES, 
% VALEURS QUE VOUS POUVEZ/DEVEZ FAIRE ÉVOLUER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tolérance
eps = 1e-8;
% nombre d'itérations max pour atteindre la convergence
maxit = 10000;

% taille de l'espace de recherche (m)
search_space = 400;

% pourcentage que l'on se fixe
percentage = 0.995;

% p pour les versions 2 et 3 (attention p déjà utilisé comme taille)
puiss = 1;

%%%%%%%%%%%%%
% À COMPLÉTER
%%%%%%%%%%%%%
% Méthode de calcul des vps utilisée
methode = "powerV12";
if q > p
    M = I'*I;
else
    M = I*I';
end
%%
% calcul des couples propres
%%
fprintf('Calcul des couples propres avec la méthode %s\n', methode )
tic
switch methode
    case "powerV12"
        [ VM, DM, it, flag ] = power_v12( M, search_space, percentage, eps, maxit );
    case "v0"
        [ VM, DM, it, flag ] = subspace_iter_v0(M, search_space, eps, maxit);
    case "v1"
        [ VM, DM, it, flag ] = subspace_iter_v1(M, search_space, percentage, eps, maxit);
    case "v2"
        [ VM, DM, it, flag ] = subspace_iter_v2(M, search_space, percentage, puiss, eps, maxit);
    case "v3"
        [ VM, DM, it, flag ] = subspace_iter_v3(M, search_space, percentage, puiss, eps, maxit);
    case "eig"
        [VM,DM] = eig(M);
end
toc
[WM,indice]=sort(diag(DM),'descend');
WM = diag(WM);
VM = VM(:,indice);
%%
% calcul des valeurs singulières
%%
Sigma = sqrt(DM);
S_div = Sigma.^(-1);
%%
% calcul de l'autre ensemble de vecteurs
%%
if q > p
    V2 = VM;
    U2 = zeros(size(I,1),size(Sigma,1));
    for k = 1 : size(Sigma,1)
        U2(:,k) = I * V2(:,k) * S_div(k,k);
    end 
else
    U2 = VM;
    V2 = zeros(size(I,2),size(Sigma,1));
    for k = 1:size(Sigma,1)
        V2(:,k) = I' * U2(:,k) *S_div(k,k);
    end
end
%%
% calcul des meilleures approximations de rang faible
%%

% vecteur pour stocker la différence entre l'image et l'image reconstuite
if size(Sigma,1) > search_space
    inter = 1:40:(search_space+40);
    inter(end) = search_space;
    differenceSVD = zeros(size(inter,2), 1);
else
    inter = 1:40:(size(Sigma,1));
    differenceSVD = zeros(size(inter,2), 1);
end


% images reconstruites 
ti = 0;
td = 0;
for k = inter

    % Calcul de l'image de rang k
    Im_k = U2(:, 1:k)*Sigma(1:k, 1:k)*V2(:, 1:k)';

    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
    imagesc(Im_k),
    title("Image reconstruite avec la méthode " + methode)
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD(td) = sqrt(sum(sum((I-Im_k).^2)));
end

% Figure des différences entre image réelle et image reconstruite
ti = ti+1;
figure(ti)
hold on 
plot(inter, differenceSVD, 'rx')
ylabel('RMSE')
xlabel('rank k')
