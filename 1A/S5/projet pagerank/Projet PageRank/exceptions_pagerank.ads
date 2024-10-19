-- Définition des exceptions pour PageRank

package Exceptions_PageRank is 

    -- Déclaration des exceptions.
    Nom_Fichier_Source_Exception : Exception;
    Option_Inexistante_Exception : Exception;
    Programme_Non_Implemente_Exception : Exception;
    Fichier_Non_Valide_Exception : Exception;

    Alpha_Exception : Exception;
    K_Exception : Exception;
    Epsilon_Exception : Exception;


    -- Messages d'erreurs associés aux exceptions.
    MESSAGE_NOM_FICHIER_SOURCE_EXCEPTION : constant String := 
        "Le fichier source doit être d'extension .net ou .txt et doit être placé comme dernier argument de la ligne de commandes.";
    MESSAGE_OPTION_INEXISTANTE_EXCEPTION : constant String :=
        "Une option inexistante a été saisie dans la ligne de commandes. Elle sera ignorée.";
    MESSAGE_PROGRAMME_NON_IMPLEMENTE_EXCEPTION : constant String :=
        "Cette partie du programme n'est pas encore implémentée.";
    MESSAGE_FICHIER_NON_VALIDE_EXCEPTION : constant String :=
        "Le fichier source ne décrit pas un graphe correct pour PageRank.";
    MESSAGE_ALPHA_EXCEPTION : constant String :=
        "La valeur de Alpha doit être une valeur réelle comprise entre 0.0 et 1.0 au sens large.";
    MESSAGE_K_EXCEPTION : constant String :=
        "La valeur de K doit être un entier positif.";
    MESSAGE_EPSILON_EXCEPTION : constant String :=
        "La valeur de Epsilon doit être un réel positif.";

end Exceptions_PageRank;