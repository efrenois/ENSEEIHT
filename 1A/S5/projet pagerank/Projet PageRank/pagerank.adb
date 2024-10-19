-- Modules nécessaires.
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Command_Line;          use Ada.Command_Line;
with Exceptions_PageRank;       use Exceptions_PageRank;    -- Définitions des exceptions dans exceptions_pagerank.ads
with Ligne_Commandes;           use Ligne_Commandes;        -- Module qui traite la ligne de commandes
with MP;                                                    -- Module des matrices pleines
with MC;                                                    -- Module des matrices creuses

procedure PageRank is


    -- Execution de PageRank, nécessaire pour l'instanciation des packages génériques.
    procedure Execution_PageRank (
        Nb_Noeuds : in Integer;
        Alpha : in Float;
        K : in Integer;
        Epsilon : in Float;
        Choix_Algo : in T_Algo;
        Prefixe : in Unbounded_String;
        Nom_Fichier : in Unbounded_String
        ) is


        -- Instanciation du package Matrice Pleines.
        package MP_PageRank is
            new MP (Nb_Noeuds);
        use MP_PageRank;

        -- Instanciation du package Matrice Creuses.
        package MC_PageRank is
            new MC (Nb_Noeuds);
        use MC_PageRank;

    begin
        -- Calculer le classement PageRank.
        if Choix_Algo = PLEINES then
            declare
                Matrice_Adjacence : T_Matrice;                          -- Matrice d'adjacence pour matrices pleines
                ee : T_Matrice;
                G : T_Matrice;
                S : T_Matrice;
                Pi_Matrices_Pleines : T_Vecteur_Float_MP;               -- Vecteur des poids des pages pour les matrices pleines
                Classement_Matrices_Pleines : T_Vecteur_Integer_MP;     -- Vecteur du classement des pages pour les matrices pleines
            begin
                -- Remplir la matrice d'adjacence à partir des données du fichier source.
                Remplir_Matrice_Adjacence(To_String(Nom_Fichier), Matrice_Adjacence);

                -- Calculer le poids de toutes les pages par itération de produit matriciel avec des matrices pleines.
                Construire_ee_S_G(Matrice_Adjacence, Alpha, ee, S, G);

                -- Réaliser l'itération du calcul des poids.
                Pi_Matrices_Pleines := Iteration_Matriciel(G, K, Epsilon);

                -- Initialiser le classement.
                for i in 0..Nb_Noeuds-1 loop
                    Classement_Matrices_Pleines(i) := i;
                end loop;

                -- Classer les pages par ordre de poids décroissant.
                Classer(Pi_Matrices_Pleines, Classement_Matrices_Pleines);

                -- Ecrire les fichiers résultats.
                Ecrire_Fichier_Poids(To_String(Prefixe), Pi_Matrices_Pleines, Nb_Noeuds, Alpha, K);
                Ecrire_Fichier_PageRank(To_String(Prefixe), Classement_Matrices_Pleines, Nb_Noeuds);
            end;

        else
            declare
                Matrice_Adjacence_Creuse : T_Mat_C;                     -- Matrice d'adjacence pour matrices creuses
                Pi_Matrices_Creuses : T_Vecteur_Float_MC;               -- Vecteur des poids des pages pour les matrices creuses
                Classement_Matrices_Creuses : T_Vecteur_Integer_MC;     -- Vecteur du classement des pages pour les matrices creuses
            begin
                -- Remplir la matrice d'adjacence à partir des données du fichier source.
                Calculer_Matrice_Adjacence_Creuse(To_String(Nom_Fichier), Matrice_Adjacence_Creuse);

                -- Calculer le poids de toutes les pages par itération de produit matriciel avec des matrices creuses.
                Iterer_Calcul_Poids(Pi_Matrices_Creuses, Alpha, K, Epsilon, Matrice_Adjacence_Creuse);

                -- Initialiser le classement.
                for i in 0..Nb_Noeuds-1 loop
                    Classement_Matrices_Creuses(i) := i;
                end loop;

                -- Classer les pages par ordre de poids décroissant.
                Classer(Pi_Matrices_Creuses, Classement_Matrices_Creuses);

                -- Ecrire les fichiers résultats.
                Ecrire_Fichier_Poids(To_String(Prefixe), Pi_Matrices_Creuses, Nb_Noeuds, Alpha, K);
                Ecrire_Fichier_PageRank(To_String(Prefixe), Classement_Matrices_Creuses, Nb_Noeuds);

                -- Libérer l'espace mémoire pris par la matrice d'adjacence.
                Detruire(Matrice_Adjacence_Creuse);
            end;

        end if;
        
        exception
            when Programme_Non_Implemente_Exception => Put_Line(MESSAGE_PROGRAMME_NON_IMPLEMENTE_EXCEPTION);
    end Execution_PageRank;

    -- Déclaration des variables.
    Alpha : Float;
    K : Integer;
    Epsilon : Float;
    Choix_Algo : T_Algo;
    Prefixe : Unbounded_String;
    Nom_Fichier : Unbounded_String; 
    Nb_Noeuds : Integer;

begin
    if Argument_Count = 0 then
            -- Afficher un message sur l'explication de la ligne de commandes.
            Afficher_Aide_Ligne_Commandes;
    else
        -- Traiter la ligne de commandes.
        Traiter_Ligne_Commandes(Alpha, K, Epsilon, Choix_Algo, Prefixe, Nom_Fichier);

        -- Récupérer le nombre de noeuds du graphe source.
        Nb_Noeuds := Nombre_Noeuds(To_String(Nom_Fichier));

        -- Exécuter les algorithmes.
        Execution_PageRank(Nb_Noeuds, Alpha, K, Epsilon, Choix_Algo, Prefixe, Nom_Fichier);            
    end if;
    
    exception
        when Nom_Fichier_Source_Exception => Put_Line(MESSAGE_NOM_FICHIER_SOURCE_EXCEPTION);
        when Name_Error => Put_Line("Le fichier " & To_String(Nom_Fichier) & " n'a pas été trouvé. Vérifiez qu'il se trouve dans le bon répertoire.");
        when Fichier_Non_Valide_Exception => Put_Line(MESSAGE_FICHIER_NON_VALIDE_EXCEPTION);
end PageRank;