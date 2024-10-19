with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Command_Line;          use Ada.Command_Line;
with Exceptions_PageRank;       use Exceptions_PageRank;
with Ada.IO_Exceptions;


package body Ligne_Commandes is

    procedure Traiter_Ligne_Commandes (
        Alpha : out Float;                      -- Valeur de Alpha entrée par l'utilisateur (ou celle par défaut)
        K : out Integer;                        -- Valeur de K entrée par l'utilisateur (ou celle par défaut)
        Epsilon : out Float;                    -- Valeur de Epsilon entrée par l'utilisateur (ou celle par défaut)
        Choix_Algo : out T_Algo;                -- Choix de l'algorithme par l'utilisateur (ou celui par défaut)
        Prefixe : out Unbounded_String;         -- Nom des fichiers de sortie entré par l'utilisateur (ou celui par défaut)
        Nom_Fichier : out Unbounded_String      -- Nom du fichier source entré par l'utilisateur
    ) is
        i : Integer;                            -- Compteur de boucle
        Nouveau_Alpha : Float;                  -- Potentielle nouvelle valeur de Alpha (si elle vérifie les bonnes conditions)
        Nouveau_K : Integer;                    -- Potentielle nouvelle valeur de K (si elle vérifie les bonnes conditions)
        Nouveau_Epsilon : Float;                -- Potentielle nouvelle valeur de Epsilon (si elle vérifie les bonnes conditions)
        Extension_Fichier : String (1..4);      -- Extension du fichier pris en entrée.
        Nom_Fichier_Aux : constant String := Argument(Argument_Count);
    begin
        -- Initialiser les paramètres de calcul.
        Alpha := 0.85;
        K := 150;
        Epsilon := 0.0;
        Choix_Algo := CREUSES;
        Prefixe := To_Unbounded_String("output");


        -- Traiter le nom du fichier.
        if Nom_Fichier_Aux'Length < 4 then
            raise Nom_Fichier_Source_Exception;
        end if;
        Extension_Fichier := Nom_Fichier_Aux(Nom_Fichier_Aux'Last-3..Nom_Fichier_Aux'Last);
        if not(Extension_Fichier = ".txt" or Extension_Fichier = ".net") then
            raise Nom_Fichier_Source_Exception;
        else
            Nom_Fichier := To_Unbounded_String(Nom_Fichier_Aux);
        end if;


        -- Traiter les paramètres de la ligne de commandes.
        i := 1;
        while (i < Argument_Count) loop
            begin
                -- Traiter l'argument i de la ligne de commande. 
                if Argument(i) = "-A" then
                    -- Traiter l'option -A.
                    i := i+1;
                    Nouveau_Alpha := Float'Value(Argument(i));

                    if Nouveau_Alpha >= 0.0 and Nouveau_Alpha <= 1.0 then
                        Alpha := Nouveau_Alpha;
                    else
                        raise Alpha_Exception;
                    end if;

                elsif Argument(i) = "-K" then 
                    -- Traiter l'option -K.
                    i := i+1;
                    Nouveau_K := Integer'Value(Argument(i));

                    if Nouveau_K >= 0 then
                        K := Nouveau_K;
                    else
                        raise K_Exception;
                    end if;

                elsif Argument(i) = "-E" then 
                    -- Traiter l'option -E. 
                    i := i+1;
                    Nouveau_Epsilon := Float'Value(Argument(i));

                    if Nouveau_Epsilon >= 0.0 then
                        Epsilon := Nouveau_Epsilon;
                    else
                        raise Epsilon_Exception;
                    end if;

                elsif Argument(i) = "-P" then 
                    -- Traiter l'option -P.
                    Choix_Algo := PLEINES;

                elsif Argument(i) = "-C" then 
                    -- Traiter l'option -C.
                    Choix_Algo := CREUSES;

                elsif Argument(i) = "-R" then 
                    -- Traiter l'option -R.
                    i := i+1;
                    Prefixe := To_Unbounded_String(Argument(i));

                else
                    raise Option_Inexistante_Exception;

                end if;

                i := i+1;
            
                exception
                    when Option_Inexistante_Exception => Put_Line(MESSAGE_OPTION_INEXISTANTE_EXCEPTION);
                        i := i+1;

                    when Data_Error =>
                        Put_Line("Un argument de la ligne de commandes n'a pas le bon type, cet argument ainsi que sa valeur seront ignorés.");
                        i := i+1;

                    when Alpha_Exception => Put_Line(MESSAGE_ALPHA_EXCEPTION);
                    when K_Exception => Put_Line(MESSAGE_K_EXCEPTION);
                    when Epsilon_Exception => Put_Line(MESSAGE_EPSILON_EXCEPTION);
            end;

        end loop;
    end Traiter_Ligne_Commandes;


    procedure Afficher_Aide_Ligne_Commandes is
    begin
        Put_Line("Le programme PageRank nécessite au moins un argument dans la ligne de commandes.");
        Put_Line("Voici une liste exhaustive des options utilisables pour le programme PageRank :");
        Put_Line("-- L'option -A permet de définir la valeur de Alpha, sa valeur par défaut est 0.85. " & MESSAGE_ALPHA_EXCEPTION);
        Put_Line("-- L'option -K petmet de définir la valeur de K, sa valeur par défaut est 150. " & MESSAGE_K_EXCEPTION);
        Put_Line("-- L'option -E permet de définir la valeur de Epsilon, sa valeur par défaut est 0.0. " & MESSAGE_EPSILON_EXCEPTION);
        Put_Line("-- L'option -P permet de choisir l'algorithme du PageRank implémenté par les matrices pleines.");
        Put_Line("-- L'option -C permet de choisir l'algorithme du PageRank implémenté par les matrices creuses.");
        Put_Line("-- L'option -R permet de choisir le préfixe des fichiers résultats, sa valeur par défaut est output.");
    end Afficher_Aide_Ligne_Commandes;


    function Nombre_Noeuds (Nom_Fichier : in String) return Integer is
        Fichier : File_Type;
        Nb_Noeuds : Integer;
    begin
        Open(Fichier, In_File, Nom_Fichier);
        Get(Fichier, Nb_Noeuds);
        Close(Fichier);
        return Nb_Noeuds;

        exception
            when ADA.IO_EXCEPTIONS.DATA_ERROR => raise Fichier_Non_Valide_Exception;
    end Nombre_Noeuds;

end Ligne_Commandes;