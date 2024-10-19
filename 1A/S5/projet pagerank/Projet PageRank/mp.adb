with Ada.Text_IO;                       use Ada.Text_IO;
with Ada.Float_Text_IO;                 use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;               use Ada.Integer_Text_IO;

package body MP is 


    procedure Initialiser (Matrice : out T_Matrice; Element: in Float) is
    begin
        -- Parcours des lignes
        for i in 0..TAILLE-1 loop  
            -- Parcours des colonnes       
            for j in 0..TAILLE-1 loop     
                Matrice(i,j) := Element;
            end loop;
        end loop;
    end Initialiser;


    procedure Afficher (Matrice : T_Matrice) is
    begin
        for i in 0..TAILLE-1 loop
            for j in 0..TAILLE-1 loop
                Put(Matrice(i,j));
            end loop;
            New_Line;
        end loop;
        New_Line;
    end Afficher;


    procedure Afficher (Vecteur : in T_Vecteur_Float_MP) is
    begin
        for i in 0..TAILLE-1 loop
            Put(Vecteur(i));
            New_Line;
        end loop;
        New_Line;
    end Afficher;


    procedure Modifier (Matrice : in out T_Matrice; Element : in Float; Ligne : in Integer; Colonne : in Integer) is
    begin
        Matrice(Ligne, Colonne) := Element;
    end Modifier;


    procedure Additionner (Matrice1 : in T_Matrice; Matrice2 : in T_Matrice; Resultat : out T_Matrice) is
    begin 
        -- Parcours des lignes
        for i in 0..TAILLE-1 loop  
            -- Parcours des colonnes      
            for j in 0..TAILLE-1 loop     
                Resultat(i,j) := Matrice1(i,j) + Matrice2(i,j);
            end loop;
        end loop;
    end Additionner;


    procedure Soustraire (Vecteur1 : in T_Vecteur_Float_MP; Vecteur2 : in T_Vecteur_Float_MP; Resultat : out T_Vecteur_Float_MP) is 
    begin 
        -- Parcours du vecteur.
        for i in 0..TAILLE-1 loop       
            Resultat(i) := Vecteur1(i) - Vecteur2(i);
        end loop;
    end Soustraire;


    procedure Multiplier (Matrice1 : in T_Matrice; Matrice2 : in T_Matrice; Resultat : out T_Matrice) is 
    begin
        -- Parcours des lignes
        for i in 0..TAILLE-1 loop
            -- Parcours des colonnes      
            for j in 0..TAILLE-1 loop 
                Resultat(i,j) := 0.0;
                --Multiplication de chaque termes   
                for k in 0..TAILLE-1 loop
                    Resultat(i,j) := Resultat(i,j) + Matrice1(i,k)*Matrice2(k,j);
                end loop;
            end loop;
        end loop;
    end Multiplier;


    procedure Multiplier (Matrice : in T_Matrice; Scalaire : in Float; Resultat : out T_Matrice) is
    begin 
        -- Parcours des lignes
        for i in 0..TAILLE-1 loop  
            -- Parcours des colonnes      
            for j in 0..TAILLE-1 loop 
                Resultat(i,j) := Matrice(i,j)*Scalaire;
            end loop;
        end loop;
    end Multiplier;


    procedure Multiplier (Matrice : in T_Matrice; Vecteur : in T_Vecteur_Float_MP; Resultat : out T_Vecteur_Float_MP) is
        Somme_Colonne : Float;

    begin 
        for j in 0..TAILLE-1 loop  
            Somme_Colonne := 0.0;  
            for i in 0..TAILLE-1 loop 
                Somme_Colonne := Somme_Colonne + Vecteur(i)*Matrice(i,j);
            end loop;
            Resultat(j) := Somme_Colonne;
        end loop;
    end Multiplier;


    function Norme_Infinie (Vecteur : in T_Vecteur_Float_MP) return Float is

        -- Trouver le maximum d'un tableau.
        function Max (Tab : in T_Vecteur_Float_MP) return Float is
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

        Vec_Norme : T_Vecteur_Float_MP;

    begin
        for i in 0..TAILLE-1 loop
            Vec_Norme(i) := ABS(Vecteur(i));
        end loop;
        return Max(Vec_Norme);
    end Norme_Infinie;


    procedure Remplir_Matrice_Adjacence (Nom_Fichier : in String; Matrice_Adjacence : in out T_Matrice) is
        Fichier : File_Type;
        Noeud_Un, Noeud_Deux : Integer;
    begin
        -- Initialiser la matrice d'adjacence.
        Initialiser(Matrice_Adjacence, 0.0);
        
        -- Ouvrir le fichier source en lecture.
        Open(Fichier, In_File, Nom_Fichier);
        Skip_Line(Fichier);

        while not(End_Of_File(Fichier)) loop
            -- Récupérer les deux entiers de la ligne courante.
            Get(Fichier, Noeud_Un);
            Get(Fichier, Noeud_Deux);

            -- Ajouter le lien des deux noeuds dans Matrice_Adjacence.
            Modifier(Matrice_Adjacence, 1.0, Noeud_Un, Noeud_Deux);

            Skip_Line(Fichier);
        end loop;

        Close(Fichier);
    end Remplir_Matrice_Adjacence;


    procedure Construire_ee_S_G (Matrice_Adjacence : in T_Matrice; Alpha : in Float; ee : out T_Matrice; S : out T_Matrice; G : out T_Matrice) is
        Somme_Ligne : Float; -- Compteur d'éléments non nuls sur la ligne i de la Matrice d'adjacence
        M_Aux_1 : T_Matrice;
        M_Aux_2 : T_Matrice;
    
    begin
        -- Construction de la matrice ee
        Initialiser(ee, 1.0);

        --Construction de la matrice S 
        for i in 0..TAILLE-1 loop
            Somme_Ligne := 0.0;

            -- Compter le nombre d'éléments non nuls sur la ligne i de la matrice d'adjacence 
            for j in 0..TAILLE-1 loop
                if Matrice_Adjacence(i,j) /= 0.0 then 
                    Somme_Ligne := Somme_Ligne + 1.0;
                else 
                    null;
                end if;
            end loop;

            -- Remplir la ligne i de S 
            if Somme_Ligne = 0.0 then
                for j in 0..TAILLE-1 loop
                    S(i,j) := 1.0/Float(TAILLE);
                end loop;
            else
                for j in 0..TAILLE-1 loop
                    S(i,j) := Matrice_Adjacence(i,j)/Somme_Ligne;
                end loop;
            end if;
        end loop;

        -- Construire la matrice G 
        Multiplier(S,Alpha,M_Aux_1);
        Multiplier(ee,(1.0-Alpha)/Float(TAILLE),M_Aux_2);
        Additionner(M_Aux_1, M_Aux_2, G);
    end Construire_ee_S_G;



    function Iteration_Matriciel (G: in T_Matrice; K: in Integer; Epsilon : in Float) return T_Vecteur_Float_MP is
        Pi : T_Vecteur_Float_MP;           -- Vecteur poids
        k_boucle : Integer;             -- Indice de boucle pour l'itération
        Ancien_Pi : T_Vecteur_Float_MP;    -- Pour comparer la nouvelle valeur de Pi avec l'ancienne
        Continuer : Boolean := True;    -- Continuer les tours de boucles tant que les valeurs des différents Pi consécutifs est plus petit qu'Epsilon
        Comparaison : T_Vecteur_Float_MP;  -- Pour comparer les valeurs de Pi et de Ancien_Pi

    begin 
        -- Initialisation du vecteur Pi.
        for i in 0..TAILLE-1 loop
            Pi(i) := 1.0/Float(TAILLE);
        end loop;

        -- Itérer le produit matriciel pour obtenir le vecteur Pi final.
        k_boucle := 1;
        while k_boucle <= K and Continuer loop
            Ancien_Pi := Pi;
            Multiplier(G,Ancien_Pi,Pi);
            Soustraire(Ancien_Pi,Pi,Comparaison);

            if Norme_Infinie(Comparaison) < Epsilon then
                Continuer := False;
            end if;

            k_boucle := k_boucle + 1;
        end loop;

        return Pi;
    end Iteration_Matriciel;


    procedure Classer (Poids : in out T_Vecteur_Float_MP; Classement : in out T_Vecteur_Integer_MP) is

        -- Trouver l'indice du maximum d'un sous-tableau.
        function Indice_Max (Tab : in T_Vecteur_Float_MP; Debut : in Integer; Fin : in Integer) return Integer is
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
        Poids : in T_Vecteur_Float_MP;
        Nb_Noeuds : in Integer;
        Alpha : in Float;
        K : in Integer
    ) is
        Fichier : File_Type;

    begin
        -- Créer et ouvrir le fichier poids en écriture.
        Create(Fichier, Out_File, Nom_Output & ".prw");

        -- Écrire la première ligne de Fichier avec les paramètres.
        Put(Fichier, Nb_Noeuds, 1);
        Put(Fichier, ' ');
        Put(Fichier, Alpha, Exp => 0);
        Put(Fichier, ' ');
        Put(Fichier, K, 1);
        New_Line(Fichier);

        -- Écrire le poids des pages selon Poids.
        for i in 0..Nb_Noeuds-1 loop
            Put(Fichier, Poids(i), Exp => 0);
            New_Line(Fichier);
        end loop;

        Close(Fichier);
    end Ecrire_Fichier_Poids;


    procedure Ecrire_Fichier_PageRank (Nom_Output : in String; Classement : in T_Vecteur_Integer_MP; Nb_Noeuds : in Integer) is 
        Fichier : File_Type;

    begin
        -- Créer et ouvrire le fichier PageRank en écriture.
        Create(Fichier, Out_File, Nom_Output & ".pr");

        -- Écrire le classement des pages.
        for i in 0..Nb_Noeuds-1 loop
            Put_Line(Fichier, Integer'image(Classement(i)));
        end loop;

        Close(Fichier);
    end Ecrire_Fichier_PageRank;

end MP;