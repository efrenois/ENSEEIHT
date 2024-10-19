-- Procédures et fonctions permettant d'effectuer l'algorithme PageRank
-- dans le cas d'une implémentation par des matrices creuses.

generic

    TAILLE : Integer;

package MC is

    Index_Exception : Exception;

    type T_Mat_C is limited private;
    type T_Vec_C is limited private;

    type T_Vecteur_Float_MC is array (0..TAILLE-1) of Float;
    type T_Vecteur_Integer_MC is array (0..TAILLE-1) of Integer;


    ---------------------------------------------------------------------------
    --                       Manipulation des matrices                       --
    ---------------------------------------------------------------------------


    -- Initialiser une matrice.
    --
    -- Paramètres :
    --      Mat : in out T_Mat_C
    -- 
    -- Pré-conditions : Aucune
    -- Post-conditions : Aucune
    procedure Initialiser (Mat : out T_Mat_C);


    -- Libérer l'espace mémoire d'un vecteur creux.
    -- 
    -- Paramètres :
    --      Matrice : in T_Mat_C
    --
    -- Pré-conditions : Aucune
    -- Post-conditions : Vecteur = NULL
    procedure Detruire (Matrice : in T_Mat_C);


    -- Afficher une matrice creuse.
    -- 
    -- Paramètres : 
    --      Mat : in T_Mat_C
    -- 
    -- Pré-conditions : Aucune
    -- Post-conditions : Aucune
    procedure Afficher (Mat : in T_Mat_C);


    -- Modifier un élément.
    --
    -- Paramètres :
    --      Mat : in out T_Mat_C
    --      Element : in Float
    --      Ligne : in Integer
    --      Colonne : in Integer
    -- 
    -- Pré-conditions : 0 <= Ligne < TAILLE et 0 <= Colonne < TAILLE
    -- Post-conditions : Mat(Ligne, Colonne) = Element
    procedure Modifier (Mat : in out T_Mat_C; Element : in Float; Ligne : in Integer; Colonne : in Integer);


    -- Calculer la matrice d'adjacence à partir du graphe source.
    -- 
    -- Paramètres : 
    --      Nom_Fichier : in String
    --      Mat_Adj_C : out T_Mat_C     -- Matrice d'adjacence
    --
    -- Pré-conditions : Le fichier Nom_Fichier contient un graphe valide
    -- Post-conditions : Mat_Adj_C est la matrice d'adjacence du graphe contenu dans Nom_Fichier
    procedure Calculer_Matrice_Adjacence_Creuse (Nom_Fichier : in String; Mat_Adj_C : out T_Mat_C);


    -- Itération matricielle du calcul du poids.
    -- 
    -- Paramètres : 
    --      Pi : out T_Vecteur_Float_MC     -- Vecteur poids
    --      Alpha : in Float
    --      K : in Integer
    --      Epsilon : in Float
    --      Mat_Adj_C : in T_Mat_C          -- Matrice d'adjacence du graphe
    -- 
    -- Pré-conditions : 0 <= Alpha <= 1 ET K >= 0 ET Epsilon >= 0
    -- Post-conditions : Aucune
    procedure Iterer_Calcul_Poids (Pi : out T_Vecteur_Float_MC; Alpha : in Float; K : in Integer; Epsilon : in Float; Mat_Adj_C : in T_Mat_C);


    -- Classer les poids et les pages par ordre de poids décroissant.
    -- 
    -- Paramètres : 
    --      Poids : in out T_Vecteur_Float_MC           -- Poids des pages
    --      Classement : in out T_Vecteur_Integer_MC    -- Classement des pages
    --
    -- Pré-conditions : Aucune
    -- Post-conditions : Poids est trié par ordre décroissant et Classement a été trié de la même façon
    procedure Classer (Poids : in out T_Vecteur_Float_MC; Classement : in out T_Vecteur_Integer_MC);


    -- Écrire le fichier poids.
    -- 
    -- Paramètres :
    --      Nom_Fichier : in String -- Nom du fichier dont on va lire les données
    --      Poids : in T_Vecteur_Float
    --      Nb_Noeuds : in Integer
    --      Alpha : in Float
    --      K : in Integer
    --
    -- Pré-conditions : Poids est bien le classement décroissant des poids des pages
    -- Post-conditions : Le fichier créé est bien le fichier poids demandé dans l'énoncé
    procedure Ecrire_Fichier_Poids (
        Nom_Output : in String;
        Poids : in T_Vecteur_Float_MC;
        Nb_Noeuds : in Integer;
        Alpha : in Float;
        K : in Integer
    );


    -- Écrire le fichier PageRank.
    -- 
    -- Paramètres :
    --      Nom_Fichier : in String -- Nom du fichier dont on va lire les données
    --      Classement : in T_Vecteur_Integer
    --      Nb_Noeuds : in Integer
    --
    -- Pré-conditions : Classement est bien le classement décroissant des pages
    -- Post-conditions : Le fichier créé est bien le fichier PageRank demandé dans l'énoncé   
    procedure Ecrire_Fichier_PageRank (
        Nom_Output : in String; 
        Classement : in T_Vecteur_Integer_MC; 
        Nb_Noeuds : in Integer
    );


private

    -- On construit ici une matrice avec un vecteur creu de vecteurs creux.
    -- On considèrera que T_Mat_C constitue la ligne des vecteurs creux,
    -- et que tous ces éléments sont donc des T_Vec_C qui constitue les colonnes
    -- de la matrice.
    -- On utilise des listes doublement chaînées.

    type T_Cell_Vec;
    type T_Cell_Mat;
    
    type T_Vec_C is access T_Cell_Vec;
    type T_Mat_C is access T_Cell_Mat;

    type T_Cell_Vec is record
        Indice : Integer;
        Valeur : Float;
        Suivant : T_Vec_C;
        Precedent : T_Vec_C;
    end record;

    type T_Cell_Mat is record
        Indice : Integer;
        Valeur : T_Vec_C;
        Suivant : T_Mat_C;
        Precedent : T_Mat_C;
    end record;


end MC;