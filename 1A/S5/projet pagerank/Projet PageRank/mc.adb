with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;         use Ada.Float_Text_IO;
with Exceptions_PageRank;       use Exceptions_PageRank;
with Ada.IO_Exceptions;
with Ada.Unchecked_Deallocation;

package body MC is

    PRECISION : constant Float := 0.000001;     -- Précision pour les calculs de flottants

    -- Détruire une cellule d'un vecteur.
    procedure Free is
        new Ada.Unchecked_Deallocation (Object => T_Cell_Vec, Name => T_Vec_C);

    -- Détruire une cellule d'une matrice.
    procedure Free is
        new Ada.Unchecked_Deallocation (Object => T_Cell_Mat, Name => T_Mat_C);

    ---------------------------------------------------------------------------
    --                       Manipulation des matrices                       --
    ---------------------------------------------------------------------------
    
    -- Initialiser une matrice.
    procedure Initialiser (Mat : out T_Mat_C) is 
    begin
        Mat := NULL;
    end Initialiser;


    -- Libérer l'espace mémoire d'un vecteur.
    procedure Detruire (Vecteur : in T_Vec_C) is
        Curseur : T_Vec_C := Vecteur;           -- Copie pour parcourir le vecteur
        Copie_Curseur : T_Vec_C := Vecteur;     -- Copie qui permettra de supprimer les cellules
    begin
        while Curseur /= NULL loop
            Copie_Curseur := Curseur;
            Curseur := Copie_Curseur.all.Suivant;
            Free(Copie_Curseur);
        end loop;
    end Detruire;


    -- Libérer l'espace mémoire d'un vecteur.
    procedure Detruire (Matrice : in T_Mat_C) is
        Curseur : T_Mat_C := Matrice;           -- Copie pour parcourir le vecteur
        Copie_Curseur : T_Mat_C := Matrice;     -- Copie qui permettra de supprimer les cellules
    begin
        while Curseur /= NULL loop
            Copie_Curseur := Curseur;
            Curseur := Copie_Curseur.all.Suivant;
            Detruire(Copie_Curseur.all.Valeur);
            Free(Copie_Curseur);
        end loop;
    end Detruire;


    -- Afficher une matrice.
    procedure Afficher (Mat : in T_Mat_C) is

        -- Afficher une cellule.
        procedure Afficher_Cellule (Cell : in T_Cell_Vec) is
        begin
            Put("    ");
            Put(Cell.Indice, 1);
            Put(' ');
            Put(Cell.Valeur, Exp => 0);
            Put(' ');

            if Cell.Suivant = NULL then
                Put("NULL");
            end if;
            Put(' ');
            if Cell.Precedent = NULL then
                Put("NULL");
            end if;
            New_Line;
        end Afficher_Cellule;

        Curseur_Lig : T_Mat_C := Mat;
        Curseur_Col : T_Vec_C;

    begin
        -- Traiter le cas où la matrice est nulle.
        if Curseur_Lig = NULL then
            Put_Line("La matrice demandée est vide.");
        end if;

        -- Parcourir toute la ligne.
        while Curseur_Lig /= NULL loop
            Curseur_Col := Curseur_Lig.all.Valeur;

            Put_Line("Colonne n°" & Integer'image(Curseur_Lig.all.Indice));

            -- Parcourir toutes les colonnes.
            while Curseur_Col /= NULL loop
                Afficher_Cellule(Curseur_Col.all);
                Curseur_Col := Curseur_Col.all.Suivant;
            end loop;
            New_Line;

            Curseur_Lig := Curseur_Lig.all.Suivant;
        end loop;
        New_Line;
    end Afficher;

    
    -- Modifier un élément.
    procedure Modifier (Mat : in out T_Mat_C; Element : in Float; Ligne : in Integer; Colonne : in Integer) is
        Curseur_Lig : T_Mat_C := Mat;   -- Curseur qui parcours la ligne
        Copie_Curseur_Lig : T_Mat_C;    -- Copie du curseur Curseur_Lig
        Curseur_Col : T_Vec_C;          -- Curseur qui parcours les colonnes
        Copie_Curseur_Col : T_Vec_C;    -- Copie du curseur Curseur_Col
        New_Cell_Lig : T_Mat_C;         -- Cellule qui va être créée lorsqu'un nouvel élément doit être ajouté sur la ligne
        New_Cell_Col : T_Vec_C;         -- Cellule qui va être créée lorsqu'un nouvel élément doit être ajouté sur une colonne
        Continuer : Boolean := True;    -- Permet de sortir d'une boucle lorsque le traitement du nouvel élément a été effectué
    begin
        if Mat = NULL then
            -- Créer le premier élément de la matrice.
            New_Cell_Col := new T_Cell_Vec'(Ligne, Element, NULL, NULL);
            Mat := new T_Cell_Mat'(Colonne, New_Cell_Col, NULL, NULL);
        else
            Copie_Curseur_Lig := Curseur_Lig;
            while Curseur_Lig /= NULL and Continuer loop

                if Curseur_Lig.all.Indice < Colonne then
                    -- Avancer dans la liste ligne.
                    Curseur_Lig := Curseur_Lig.all.Suivant;
                    if Curseur_Lig /= NULL then
                        Copie_Curseur_Lig := Curseur_Lig;
                    end if;

                elsif Curseur_Lig.all.Indice = Colonne then
                    Curseur_Col := Curseur_Lig.all.Valeur;

                    if Curseur_Col = NULL then
                        Curseur_Col := new T_Cell_Vec'(Ligne, Element, NULL, NULL);
                    else
                        Copie_Curseur_Col := Curseur_Col;

                        while Curseur_Col /= NULL and Continuer loop
                            if Curseur_Col.all.Indice < Ligne then
                                -- Avancer dans la liste colonne.
                                Curseur_Col := Curseur_Col.all.Suivant;
                                if Curseur_Col /= NULL then
                                    Copie_Curseur_Col := Curseur_Col;
                                end if;

                            elsif Curseur_Col.all.Indice = Ligne then
                                -- Modifier la valeur de l'élément d'indice (Ligne,Colonne).
                                Curseur_Col.all.Valeur := Element;
                                Continuer := False;

                            else
                                -- Créer un nouvel élément.
                                New_Cell_Col := new T_Cell_Vec'(Ligne, Element, Curseur_Col, Curseur_Col.all.Precedent);
                                if Curseur_Col.all.Precedent /= NULL then
                                    Curseur_Col.all.Precedent.Suivant := New_Cell_Col;
                                else
                                    Curseur_Lig.all.Valeur := New_Cell_Col;
                                end if;
                                Curseur_Col.all.Precedent := New_Cell_Col;
                                Continuer := False;
                            end if;

                        end loop;

                        if Curseur_Col = NULL then
                            -- Créer un nouvel élément à la fin de la colonne.
                            New_Cell_Col := new T_Cell_Vec'(Ligne, Element, NULL, Copie_Curseur_Col);
                            Copie_Curseur_Col.all.Suivant := New_Cell_Col;
                            Continuer := False;
                        end if;
                    end if;

                else
                    -- Créer un nouvel élément.
                    New_Cell_Col := new T_Cell_Vec'(Ligne, Element, NULL, NULL);
                    New_Cell_Lig := new T_Cell_Mat'(Colonne, New_Cell_Col, Curseur_Lig, Curseur_Lig.all.Precedent);
                    if Curseur_Lig.all.Precedent /= NULL then
                        Curseur_Lig.all.Precedent.Suivant := New_Cell_Lig;
                    else
                        Mat := New_Cell_Lig;
                    end if;
                    Curseur_Lig.all.Precedent := New_Cell_Lig;
                    Continuer := False;

                end if;
            end loop;

            if Curseur_Lig = NULL then
                -- Créer un nouvel élément à la fin de la ligne.
                New_Cell_Col := new T_Cell_Vec'(Ligne, Element, NULL, NULL);
                New_Cell_Lig := new T_Cell_Mat'(Colonne, New_Cell_Col, NULL, Copie_Curseur_Lig);
                Copie_Curseur_Lig.all.Suivant := New_Cell_Lig;
            end if;
        end if;
    end Modifier;


    procedure Calculer_Matrice_Adjacence_Creuse (Nom_Fichier : in String; Mat_Adj_C : out T_Mat_C) is
        Fichier : File_Type;
        Noeud_Un : Integer;     -- Stocker le premier noeud d'une ligne de Fichier
        Noeud_Deux : Integer;   -- Stocker le deuxième noeud d'une ligne de Fichier
    begin
        -- Initialiser la matrice d'adjacence.
        Initialiser(Mat_Adj_C);

        -- Ouvrir le fichier source en lecture.
        Open(Fichier, In_File, Nom_Fichier);

        -- On ne prend pas en compte la première ligne du fichier
        -- puisqu'elle ne donne que le nombre de noeuds et pas
        -- une transition
        Skip_Line(Fichier);

        while not(End_Of_File(Fichier)) loop
                -- Récupérer les deux entiers de la ligne courante.
                Get(Fichier, Noeud_Un);
                Get(Fichier, Noeud_Deux);

                -- Ajouter le lien des deux noeuds dans Mat_Adj_C.
                if Noeud_Un < 0 or Noeud_Un >= TAILLE or Noeud_Deux < 0 or Noeud_Deux >= TAILLE then
                    raise Fichier_Non_Valide_Exception;
                end if; 
                Modifier(Mat_Adj_C, 1.0, Noeud_Un, Noeud_Deux);

                Skip_Line(Fichier);
            end loop;

            Close(Fichier);

            exception
                when ADA.IO_EXCEPTIONS.DATA_ERROR => raise Fichier_Non_Valide_Exception; 
    end Calculer_Matrice_Adjacence_Creuse;


    procedure Calculer_Sommes_Lignes (Mat : in T_Mat_C; Sommes_Lignes : out T_Vecteur_Float_MC) is
        Curseur_Lig : T_Mat_C := Mat;       -- Curseur qui parcours la ligne de Mat
        Curseur_Col : T_Vec_C;              -- Curseur qui parcours les colonnes de Mat
    begin
        -- Initialiser le vecteur contenant les sommes des éléments de chaque ligne.
        for i in 0..TAILLE-1 loop
            Sommes_Lignes(i) := 0.0;
        end loop;


        -- Calculer un vecteur contenant les sommes des éléments sur les lignes de Mat.
        while Curseur_Lig /= NULL loop
            Curseur_Col := Curseur_Lig.all.Valeur;

            while Curseur_Col /= NULL loop
                Sommes_Lignes(Curseur_Col.all.Indice) := Sommes_Lignes(Curseur_Col.all.Indice) + Curseur_Col.all.Valeur; 
                Curseur_Col := Curseur_Col.all.Suivant;             
            end loop;

            Curseur_Lig := Curseur_Lig.all.Suivant;
        end loop;
    end Calculer_Sommes_Lignes;


    procedure Multiplier_Poids (Pi : in out T_Vecteur_Float_MC; Mat_Adj_C : in T_Mat_C; Sommes_Lignes : in T_Vecteur_Float_MC; Alpha : in Float) is 
        Curseur_Lig : T_Mat_C := Mat_Adj_C;     -- Curseur qui parcours la ligne de la matrice
        Curseur_Col : T_Vec_C;                  -- Curseur qui parcours les colonnes de la matrice
        Nouveau_Pi : T_Vecteur_Float_MC;        -- Stocker les nouvelles valeurs de Pi
        Ajout_Fixe : Float := 0.0;              -- Deuxième partie du calcul de G
        Indices_Lignes_Vides : T_Vecteur_Integer_MC;
        Nb_Lignes_Vides : Integer := 0;         -- Nombre de lignes vides de la matrice d'adjacence
    begin
        -- Deuxième partie du calcul de G (on évite la redondance).
        for i in 0..TAILLE-1 loop
            Ajout_Fixe := Ajout_Fixe + Pi(i);
        end loop;
        Ajout_Fixe := Ajout_Fixe * ((1.0-Alpha)/Float(TAILLE));
        
        -- Indices des lignes vides
        for i in 0..TAILLE-1 loop
            if ABS(Sommes_Lignes(i) - 0.0) <= PRECISION then
                Indices_Lignes_Vides(Nb_Lignes_Vides) := i;
                Nb_Lignes_Vides := Nb_Lignes_Vides + 1;
            end if;
        end loop;

        -- Traiter le cas où la somme de la ligne courante est nulle.
        for i in 0..Nb_Lignes_Vides-1 loop
            Ajout_Fixe := Ajout_Fixe + Alpha/Float(TAILLE) * Pi(Indices_Lignes_Vides(i));
        end loop;

        -- Initialiser le nouveau vecteur poids à Ajout_Fixe.
        for i in 0..TAILLE-1 loop
            Nouveau_Pi(i) := Ajout_Fixe;
        end loop;


        -- Traiter les autres cas.
        while Curseur_Lig /= NULL loop
            Curseur_Col := Curseur_Lig.all.Valeur;

            while Curseur_Col /= NULL loop
                Nouveau_Pi(Curseur_Lig.all.Indice) := Nouveau_Pi(Curseur_Lig.all.Indice) + (Alpha/Sommes_Lignes(Curseur_Col.all.Indice) * Pi(Curseur_Col.all.Indice));

                Curseur_Col := Curseur_Col.all.Suivant; 
            end loop;

            Curseur_Lig := Curseur_Lig.all.Suivant;
        end loop;

        Pi := Nouveau_Pi;

    end Multiplier_Poids;


    procedure Iterer_Calcul_Poids (Pi : out T_Vecteur_Float_MC; Alpha : in Float; K : in Integer; Epsilon : in Float; Mat_Adj_C : in T_Mat_C) is
        
        function Norme_Infinie (Vecteur : in T_Vecteur_Float_MC) return Float is
            -- Trouver le maximum d'un tableau.
            function Max (Tab : in T_Vecteur_Float_MC) return Float is
                Max : Float;

            begin
                -- Initialiser le maximum.
                Max := Tab(0);

                -- Rechercher le maximum.
                for i in 0..TAILLE-1 loop
                    if Tab(i) > Max then
                        Max := Tab(i);
                    end if;
                end loop;

                return Max;

                exception
                    when Constraint_Error => raise Index_Exception;
            end Max;

            Vec_Norme : T_Vecteur_Float_MC;

        begin
            for i in 0..TAILLE-1 loop
                Vec_Norme(i) := ABS(Vecteur(i));
            end loop;
            return Max(Vec_Norme);
        end Norme_Infinie;


        procedure Soustraire (Vecteur1 : in T_Vecteur_Float_MC; Vecteur2 : in T_Vecteur_Float_MC; Resultat : out T_Vecteur_Float_MC) is 
        begin 
            -- Parcours du vecteur.
            for i in 0..TAILLE-1 loop       
                Resultat(i) := Vecteur1(i) - Vecteur2(i);
            end loop;
        end Soustraire;


        k_boucle : Integer;                     -- Indice de boucle pour l'itération
        Continuer : Boolean := True;            -- Continuer les tours de boucles tant que les valeurs des différents Pi consécutifs est plus petit qu'Epsilon
        Ancien_Pi : T_Vecteur_Float_MC;        -- Pour comparer la nouvelle valeur de Pi avec l'ancienne
        Sommes_Lignes : T_Vecteur_Float_MC;    -- Vecteur contenant la somme des lignes de la matrice d'adjacence
        Comparaison : T_Vecteur_Float_MC;      -- Pour comparer les valeurs de Pi et de Ancien_Pi
    begin
        -- Initialisation du vecteur Pi.
        for i in 0..TAILLE-1 loop
            Pi(i) := 1.0/Float(TAILLE);
        end loop;

        -- Récupérer les sommes des lignes des éléments de la matrice d'adjacence.
        Calculer_Sommes_Lignes(Mat_Adj_C, Sommes_Lignes);

        -- Itérer le calcul du poids.
        k_boucle := 1;
        while k_boucle <= K and Continuer loop
            Ancien_Pi := Pi;
            Multiplier_Poids(Pi, Mat_Adj_C, Sommes_Lignes, Alpha);
            Soustraire(Ancien_Pi, Pi, Comparaison);

            if Norme_Infinie(Comparaison) < Epsilon then
                Continuer := False;
            end if;

            k_boucle := k_boucle + 1;
        end loop;
    end Iterer_Calcul_Poids;


    procedure Classer (Poids : in out T_Vecteur_Float_MC; Classement : in out T_Vecteur_Integer_MC) is

        -- Trouver l'indice du maximum d'un sous-tableau.
        function Indice_Max (Tab : in T_Vecteur_Float_MC; Debut : in Integer; Fin : in Integer) return Integer is
            Max : Float;
            Indice_Max : Integer;

        begin
            -- Initialiser le maximum et l'indice du maximum.
            Max := Tab(Debut);
            Indice_Max := Debut;

            -- Rechercher le maximum.
            for i in Debut..Fin loop
                if Tab(i) > Max then
                    Max := Tab(i);
                    Indice_Max := i;
                end if;
            end loop;

            return Indice_Max;

            exception
                when Constraint_Error => raise Index_Exception;
        end Indice_Max;


        Ind : Integer;
        Temp_Poids : Float;
        Temp_Classement : Integer;

    begin
        -- Trier Poids et Classement par sélection.
        for i in 0..TAILLE-1 loop

            -- Récupérer l'indice du maximum de Poids.
            Ind := Indice_Max(Poids, i, TAILLE-1);

            if Ind /= i then
                -- Echanger Poids(i) et Poids(Ind).
                Temp_Poids := Poids(i);
                Poids(i) := Poids(Ind);
                Poids(Ind) := Temp_Poids;

                -- Echanger Classement(i) et Classement(Ind).
                -- Pour avoir le même tri dans Poids et Classement.
                Temp_Classement := Classement(i);
                Classement(i) := Classement(Ind);
                Classement(Ind) := Temp_Classement;
            end if;
        end loop;

    end Classer;


    procedure Ecrire_Fichier_Poids (
        Nom_Output : in String;
        Poids : in T_Vecteur_Float_MC;
        Nb_Noeuds : in Integer;
        Alpha : in Float;
        K : in Integer
    ) is
        Fichier : File_Type;
    begin
        -- Créer et ouvrir le fichier poids en écriture.
        Create(Fichier, Out_File, Nom_Output & ".prw");

        -- Écrire la première ligne de Fichier avec les paramètres.
        Put(Fichier, Integer'image(Nb_Noeuds));
        Put(Fichier, ' ');
        Put(Fichier, Alpha, Exp => 0);
        Put(Fichier, ' ');
        Put(Fichier, Integer'image(K));
        New_Line(Fichier);

        -- Écrire le poids des pages selon Poids.
        for i in 0..Nb_Noeuds-1 loop
            Put(Fichier, Poids(i), Exp => 0);
            New_Line(Fichier);
        end loop;

        Close(Fichier);
    end Ecrire_Fichier_Poids;


    procedure Ecrire_Fichier_PageRank (Nom_Output : in String; Classement : in T_Vecteur_Integer_MC; Nb_Noeuds : in Integer) is 
        Fichier : File_Type;
    begin
        -- Créer et ouvrire le fichier PageRank en écriture.
        Create(Fichier, Out_File, Nom_Output & ".pr");

        -- Écrire le classement des pages.
        for i in 0..Nb_Noeuds-1 loop
            Put(Fichier, Classement(i), 1);
            New_Line(Fichier);
        end loop;

        Close(Fichier);
    end Ecrire_Fichier_PageRank;


end MC;
