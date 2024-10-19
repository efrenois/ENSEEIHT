-- Procédures et fonctions permettant d'effectuer l'algorithme PageRank
-- dans le cas d'une implémentation par des matrices pleines.

generic

    TAILLE : Integer;

package MP is 

    Index_Exception : Exception;

    type T_Matrice is limited private;
    type T_Vecteur_Float_MP is array (0..TAILLE-1) of Float;
    type T_Vecteur_Integer_MP is array (0..TAILLE-1) of Integer;

    ---------------------------------------------------------------------------
    --                 Manipulation des matrices et vecteurs                 --
    ---------------------------------------------------------------------------

    -- Initialiser une  matrice avec un élément.
    procedure Initialiser (Matrice : out T_Matrice; Element: in Float);

    -- Afficher une matrice.
    procedure Afficher (Matrice : in T_Matrice);

    -- Afficher un vecteur de Float.
    procedure Afficher (Vecteur : T_Vecteur_Float_MP);

    -- Multiplier deux matrices.
    procedure Multiplier (Matrice1 : in T_Matrice; Matrice2 : in T_Matrice; Resultat : out T_Matrice);



    ---------------------------------------------------------------------------
    --                    PageRank avec matrices pleines                     --
    ---------------------------------------------------------------------------

    -- Remplir la matrice d’adjacence Matrice_Adjacence à partir des données de Fichier.
    --
    -- Paramètres : 
    --      Nom_Fichier : in String – Nom du fichier dont on va lire les données
    --	    Matrice_Adjacence : in out T_Matrice
    --
    -- Pré-conditions : Aucune
    -- Post-conditions : Matrice_Adjacence est la matrice d’adjacence du graphe représenté dans Nom_Fichier
    procedure Remplir_Matrice_Adjacence (Nom_Fichier : in String; Matrice_Adjacence : in out T_Matrice);

    -- Construire les matrices ee, S et G.
    procedure Construire_ee_S_G (Matrice_Adjacence : in T_Matrice; Alpha : in Float; ee : out T_Matrice; S : out T_Matrice; G : out T_Matrice);

    -- Réaliser l'itération matriciel.
    function Iteration_Matriciel (G : in T_Matrice; K : in Integer; Epsilon : in Float) return T_Vecteur_Float_MP;

    -- Classer les poids et les pages par ordre de poids décroissant.
    procedure Classer (Poids : in out T_Vecteur_Float_MP; Classement : in out T_Vecteur_Integer_MP);


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
        Poids : in T_Vecteur_Float_MP;
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
        Classement : in T_Vecteur_Integer_MP; 
        Nb_Noeuds : in Integer
    );

private

    type T_Matrice is array (0..TAILLE-1, 0..TAILLE-1) of Float;

end MP;