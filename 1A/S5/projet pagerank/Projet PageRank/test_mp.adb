with Ada.Text_IO;               use Ada.Text_IO;
with MP;

procedure TEST_MP is

    Nb_Noeuds : constant Integer := 6;
    Precision : constant Float := 0.000001;


    -- Instanciation du package des matrices pleines.
    package MP_PageRank is
        new MP (Nb_Noeuds);
    use MP_PageRank;


    -- Test de la procédure Initialiser
    procedure Test_Initialiser (Matrice : out T_Matrice; Element : Float) is
    begin
        Initialiser(Matrice, Element);

        for i in 0..Nb_Noeuds-1 loop
            for j in 0..Nb_Noeuds-1 loop
                pragma assert (Valeur(Matrice,i,j) = Element);
            end loop;
        end loop;
        
        Put_Line("Affichage Test_Initialiser avec Element =" & Float'image(Element));
        Afficher(Matrice);

    end Test_Initialiser;


    -- Test de la procédure Modifier.
    procedure Test_Modifier (Matrice : in out T_Matrice; Element : in Float; Ligne : in Integer; Colonne : in Integer) is 
    begin
        Modifier (Matrice, Element, Ligne, Colonne);
        pragma assert (Valeur(Matrice,Ligne, Colonne) - Element <= Precision);
        Put_Line("Affichage Test_Modifier avec Element =" & Float'image(Element) & ", Ligne =" & Integer'image(Ligne) & " et Colonne =" & Integer'image(Colonne));
        Afficher(Matrice);

    end Test_Modifier;


    -- Test de la procédure Additionner.
    procedure Test_Additionner is 
        Matrice1 : T_Matrice;
        Matrice2 : T_Matrice;
        Resultat : T_Matrice;
    begin
        Initialiser(Matrice1,0.0);
        Initialiser(Matrice2,3.0);
        Additionner (Matrice1, Matrice2, Resultat);

        for i in 0..Nb_Noeuds-1 loop
            for j in 0..Nb_Noeuds-1 loop
                pragma assert (ABS(Valeur(Resultat,i,j) - (Valeur(Matrice1,i,j) + Valeur(Matrice2,i,j))) <= Precision);
            end loop;
        end loop;

        Modifier (Matrice1, 2.0, 1, 1);
        Additionner (Matrice1, Matrice2, Resultat);

        for i in 0..Nb_Noeuds-1 loop
            for j in 0..Nb_Noeuds-1 loop
                pragma assert (ABS(Valeur(Resultat,i,j) - (Valeur(Matrice1,i,j) + Valeur(Matrice2,i,j))) <= Precision);
            end loop;
        end loop;

        Put_Line("Test de Additionner réussi.");
        New_Line;

    end Test_Additionner;


    -- Test de la procédure Soustraire.
    procedure Test_Soustraire is 
        Vecteur1 : T_Vecteur_Float;
        Vecteur2 : T_Vecteur_Float;
        Resultat : T_Vecteur_Float;

    begin

        for i in 0..Nb_Noeuds-1 loop
            Vecteur1(i) := 2.0;
            Vecteur2(i) := 1.0;
        end loop;

        Soustraire (Vecteur1, Vecteur2, Resultat);

        for i in 0..Nb_Noeuds-1 loop
            pragma assert (ABS(Resultat(i) - (Vecteur1(i) - Vecteur2(i))) <= Precision);
        end loop;

        Put_Line("Test de Soustraire réussi.");
        New_Line;

    end Test_Soustraire;


    -- Test de la procédure Multiplier
    procedure Test_Multiplier_Matrices is
        Matrice1 : T_Matrice;
        Matrice2 : T_Matrice;
        Resultat : T_Matrice;

    begin
        Initialiser(Matrice1, 0.0);
        Initialiser(Matrice2, 1.0);
        Multiplier(Matrice1, Matrice2, Resultat);

        for i in 0..Nb_Noeuds-1 loop
            for j in 0..Nb_Noeuds-1 loop
                pragma assert (ABS(Valeur(Resultat, i, j)) <= Precision);
            end loop;
        end loop;

        Modifier(Matrice1, 2.0, 0, 0);
        Modifier(Matrice1, 6.0, 3, 2);
        Multiplier(Matrice1, Matrice2, Resultat);

        for i in 0..Nb_Noeuds-1 loop
            if i = 0 then
                for j in 0..Nb_Noeuds-1 loop
                    pragma assert (ABS(Valeur(Resultat, i, j) - 2.0) <= Precision);
                end loop;
            elsif i = 3 then
                for j in 0..Nb_Noeuds-1 loop
                    pragma assert (ABS(Valeur(Resultat, i, j) - 6.0) <= Precision);
                end loop;
            else
                for j in 0..Nb_Noeuds-1 loop
                    pragma assert (ABS(Valeur(Resultat, i, j)) <= Precision);
                end loop;
            end if;
        end loop;

        Put_Line("Test de Multiplier (deux matrices) réussi.");
        New_Line;

    end Test_Multiplier_Matrices;


    -- Test de la procédure Multiplier
    procedure Test_Multiplier_Matrice_Scalaire is
        Matrice : T_Matrice;
        Scalaire : Float;
        Resultat : T_Matrice;

    begin
        Initialiser(Matrice, 0.0);
        Scalaire := 0.0;
        Multiplier(Matrice, Scalaire, Resultat);

        for i in 0..Nb_Noeuds-1 loop
            for j in 0..Nb_Noeuds-1 loop
                pragma assert (ABS(Valeur(Resultat, i, j)) <= Precision);
            end loop;
        end loop;

        Modifier(Matrice, 2.0, 0, 0);
        Modifier(Matrice, 6.0, 3, 2);
        Scalaire := 2.0;
        Multiplier(Matrice, Scalaire, Resultat);

        for i in 0..Nb_Noeuds-1 loop
            for j in 0..Nb_Noeuds-1 loop
                if i = 0 and j = 0 then
                    pragma assert (ABS(Valeur(Resultat, i, j) - 4.0) <= Precision);
                elsif i = 3 and j = 2 then
                    pragma assert (ABS(Valeur(Resultat, i, j) - 12.0) <= Precision);
                else
                    pragma assert (ABS(Valeur(Resultat, i, j)) <= Precision);
                end if;
            end loop;
        end loop;

        Put_Line("Test de Multiplier (matrice par scalaire) réussi.");
        New_Line;

    end Test_Multiplier_Matrice_Scalaire;


    -- Test de la procédure Multiplier
    procedure Test_Multiplier_Vecteur_Matrice is
        Matrice : T_Matrice;
        Vecteur : T_Vecteur_Float;
        Resultat : T_Vecteur_Float;

    begin
        Initialiser(Matrice, 0.0);
        for i in 0..Nb_Noeuds-1 loop
            Vecteur(i) := 9.0;
        end loop;
        Multiplier(Matrice, Vecteur, Resultat);

        for i in 0..Nb_Noeuds-1 loop
            pragma assert (ABS(Resultat(i)) <= Precision);
        end loop;

        Modifier(Matrice, 2.0, 0, 0);
        Modifier(Matrice, 6.0, 3, 2);
        Multiplier(Matrice, Vecteur, Resultat);

        for i in 0..Nb_Noeuds-1 loop
            if i = 0 then
                pragma assert (ABS(Resultat(i) - 18.0) <= Precision);
            elsif i = 2 then
                pragma assert (ABS(Resultat(i) - 54.0) <= Precision);
            else
                pragma assert (ABS(Resultat(i)) <= Precision);
            end if;
        end loop;


        Put_Line("Test de Multiplier (deux matrices) réussi.");
        New_Line;

    end Test_Multiplier_Vecteur_Matrice;


    -- Test de la fonction Norme infinie.
    procedure Test_Norme_Infinie is
        Vecteur : T_Vecteur_Float;

    begin
        Vecteur(0) := 1.0;
        Vecteur(1) := 3.0;

        for i in 2..Nb_Noeuds-1 loop
            Vecteur(i) := 2.0;
        end loop;

        Afficher(Vecteur);
        pragma assert (ABS(Norme_Infinie(Vecteur) - 3.0) <= Precision);

        Vecteur(0) := 1.0;
        Vecteur(1) := -3.0;

        Afficher(Vecteur);
        pragma assert (ABS(Norme_Infinie(Vecteur) - 3.0) <= Precision);

        Put_Line("Test de Norme_Infinie réussi.");
        New_Line;

    end Test_Norme_Infinie;

    
    -- Test de Construire_ee_S_G
    procedure Test_Construire_ee_S_G is 
        ee : T_Matrice;
        S : T_Matrice;
        G : T_Matrice;
        Matrice_Adjacence : T_Matrice;

    begin
        -- Construction de la matrice d'adjacence de exemples/sujet/sujet.net
        Initialiser(Matrice_Adjacence, 0.0);
        Modifier(Matrice_Adjacence, 1.0, 0, 1);
        Modifier(Matrice_Adjacence, 1.0, 0, 2);
        Modifier(Matrice_Adjacence, 1.0, 2, 0);
        Modifier(Matrice_Adjacence, 1.0, 2, 1);
        Modifier(Matrice_Adjacence, 1.0, 2, 4);
        Modifier(Matrice_Adjacence, 1.0, 3, 4);
        Modifier(Matrice_Adjacence, 1.0, 3, 5);
        Modifier(Matrice_Adjacence, 1.0, 4, 3);
        Modifier(Matrice_Adjacence, 1.0, 4, 5);
        Modifier(Matrice_Adjacence, 1.0, 5, 3);

        -- Test avec les paramètres par défauts
        Put_Line("Affichage de ee, S et G avec les paramètres par défaut (alpha = 0.85 et matrice d'adjacence de exemples/sujet/sujet.net)");
        Construire_ee_S_G(Matrice_Adjacence, 0.85, ee, S, G);
        Put_Line("Matrice ee :");
        Afficher(ee);
        Put_Line("Matrice S :");
        Afficher(S);
        Put_Line("Matrice G :");
        Afficher(G);
    end Test_Construire_ee_S_G;


    -- Test de Classer
    procedure Test_Classer is
        Poids : T_Vecteur_Float;
        Classement : T_Vecteur_Integer;

    begin
        Poids(0) := 0.5;
        Poids(1) := 0.2;
        Poids(2) := 0.1;
        Poids(3) := 0.7;
        Poids(4) := 0.6;
        Poids(5) := 0.3;

        for i in 0..Nb_Noeuds-1 loop
            Classement(i) := i;
        end loop;

        Classer(Poids, Classement);

        pragma assert (ABS(Poids(0) - 0.7) <= Precision);
        pragma assert (ABS(Poids(1) - 0.6) <= Precision);
        pragma assert (ABS(Poids(2) - 0.5) <= Precision);
        pragma assert (ABS(Poids(3) - 0.3) <= Precision);
        pragma assert (ABS(Poids(4) - 0.2) <= Precision);
        pragma assert (ABS(Poids(5) - 0.1) <= Precision);

        pragma assert (Classement(0) = 3);
        pragma assert (Classement(1) = 4);
        pragma assert (Classement(2) = 0);
        pragma assert (Classement(3) = 5);
        pragma assert (Classement(4) = 1);
        pragma assert (Classement(5) = 2);

        Put_Line("Test de Classer réussi.");
        New_Line;

    end Test_Classer;


    Matrice : T_Matrice;

begin
    Test_Initialiser(Matrice, 69.0);
    Test_Modifier(Matrice, 5.0, 1, 1);
    Test_Additionner;
    Test_Soustraire;
    Test_Multiplier_Matrices;
    Test_Multiplier_Matrice_Scalaire;
    Test_Multiplier_Vecteur_Matrice;
    Test_Norme_Infinie;
    Test_Construire_ee_S_G;
    Test_Classer;

    Put_Line("Tests réussis.");

end TEST_MP;