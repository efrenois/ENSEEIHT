with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Float_Text_IO;         use Ada.Float_Text_IO;
with MC;

procedure TEST_MC is

    Nb_Noeuds : constant Integer := 6;
    -- Precision : constant Float := 0.000001;


    -- Instanciation du package des matrices creuses.
    package MC_PageRank is
        new MC (Nb_Noeuds);
    use MC_PageRank;


    -- Test de la procédure Initialiser
    procedure Test_Initialiser (Matrice : out T_Mat_C) is
    begin
        Initialiser(Matrice);
        
        Put_Line("Affichage Test_Initialiser :");
        Afficher(Matrice);

    end Test_Initialiser;


    -- Test de la procédure Modifier.
    procedure Test_Modifier (Matrice : in out T_Mat_C; Element : in Float; Ligne : in Integer; Colonne : in Integer) is 
    begin
        Modifier (Matrice, Element, Ligne, Colonne);
        Put("Affichage Test_Modifier avec Element = ");
        Put(Element, Exp => 0); 
        Put(", Ligne =" & Integer'image(Ligne) & " et Colonne =" & Integer'image(Colonne));
        New_Line;
        Afficher(Matrice);

    end Test_Modifier;


    -- Test de la procédure Calculer_Matrice_Adjacence_Creuse.
    procedure Test_Calculer_Matrice_Adjacence_Creuse is
        Matrice : T_Mat_C;
    begin
        Put_Line("Affichage Test_Calculer_Matrice_Adjacence_Creuse :");
        Calculer_Matrice_Adjacence_Creuse("exemples/sujet/sujet.net", Matrice);
        Afficher(Matrice);
    end Test_Calculer_Matrice_Adjacence_Creuse;


    Matrice_Test : T_Mat_C;     -- Matrice utilisée pour les tests.

begin
    Test_Initialiser(Matrice_Test);

    -- Test de Modifier.
    Test_Modifier(Matrice_Test, 1.0, 0, 1);
    Test_Modifier(Matrice_Test, 1.0, 0, 2);
    Test_Modifier(Matrice_Test, 1.0, 2, 0);
    Test_Modifier(Matrice_Test, 1.0, 2, 1);
    Test_Modifier(Matrice_Test, 1.0, 2, 4);
    Test_Modifier(Matrice_Test, 1.0, 3, 4);
    Test_Modifier(Matrice_Test, 1.0, 3, 5);
    Test_Modifier(Matrice_Test, 1.0, 4, 3);
    Test_Modifier(Matrice_Test, 1.0, 4, 5);
    Test_Modifier(Matrice_Test, 1.0, 5, 3);

    Initialiser(Matrice_Test);
    Test_Modifier(Matrice_Test, 69.0, 4, 2);
    Test_Modifier(Matrice_Test, 42.0, 4, 2);
    Test_Modifier(Matrice_Test, 5.2, 4, 5);
    Test_Modifier(Matrice_Test, 0.2, 1, 2);
    Test_Modifier(Matrice_Test, 0.45, 2, 3);
    Test_Modifier(Matrice_Test, 95.7, 0, 0);

    Test_Calculer_Matrice_Adjacence_Creuse;

    New_Line;
    Put_Line("Tests réussis.");

end TEST_MC;