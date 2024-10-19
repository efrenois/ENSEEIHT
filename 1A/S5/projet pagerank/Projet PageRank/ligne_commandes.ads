-- Gestion de la ligne de commandes.
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

package Ligne_Commandes is

    -- Déclaration du type pour choisir l'algorithme des matrices pleines ou creuses.
    type T_Algo is (PLEINES, CREUSES);

    -- Traiter la ligne de commandes.
    --
    -- Paramètres :
    --      Alpha : out Float
    --      K : out Integer
    --      Epsilon : out Float
    --      Choix_Algo : out T_Algo
    --      Prefixe : out String
    --      Nom_Fichier : out String
    -- 
    -- Pré-conditions : Aucune
    -- Post-conditions : Les paramètres de la ligne de commande sont correctement initialisés.
    procedure Traiter_Ligne_Commandes (
        Alpha : out Float;                      -- Valeur de Alpha entrée par l'utilisateur (ou celle par défaut)
        K : out Integer;                        -- Valeur de K entrée par l'utilisateur (ou celle par défaut)
        Epsilon : out Float;                    -- Valeur de Epsilon entrée par l'utilisateur (ou celle par défaut)
        Choix_Algo : out T_Algo;                -- Choix de l'algorithme par l'utilisateur (ou celui par défaut)
        Prefixe : out Unbounded_String;         -- Nom des fichiers de sortie entré par l'utilisateur (ou celui par défaut)
        Nom_Fichier : out Unbounded_String      -- Nom du fichier source entré par l'utilisateur
    );


    -- Afficher de l'aide sur l'utilisation de la ligne de commandes.
    -- 
    -- Paramètres : Aucun
    --
    -- Pré-conditions : Aucune
    -- Post-conditions : Aucune
    procedure Afficher_Aide_Ligne_Commandes;


    -- Retourne le nombre de noeuds du graphe source.
    --
    -- Paramètres : 
    --	Nom_Fichier : in Chaîne – Fichier dont on va lire les données
    --
    -- Type de retour : Entier représentant le nombre de noeuds du graphe
    -- Pré-conditions : Aucune
    -- Post-conditions : Le résultat renvoyé est strictement positif
    function Nombre_Noeuds (Nom_Fichier : in String) return Integer;

end Ligne_Commandes;