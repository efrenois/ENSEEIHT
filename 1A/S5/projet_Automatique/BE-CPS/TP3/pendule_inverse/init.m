% Date : September 2023
% Institution : Université de Toulouse, INP-ENSEEIHT
%               Département Sciences du Numérique
%               Informatique, Mathématiques appliquées, Réseaux et Télécommunications
%               Computer Science department
%
%--------------------------------------------------------------------------------------
%
% Initilisation pour la simulation du pendule inversé contrôlé
%
%--------------------------------------------------------------------------------------

clear all; 
close all;

% Initialisations
% ---------------

t0 = 0;             % temps initial
g = 9.81; l = 10;   % constantes
xe = [0 0 0 0]';         % (x_e, u_e) point de fonctionnement
ue = 0;             %

% Example Cas 1.1
x0 = [0 pi/10 0 0]';                       % initial point
K = [0.6700   19.9055   1.0747   1.9614];           % constant
% 'tf' (Modifier par 'Model Settings/Solver')
% 'Intégrateur' (Modifier par 'Model Settings/Solver')