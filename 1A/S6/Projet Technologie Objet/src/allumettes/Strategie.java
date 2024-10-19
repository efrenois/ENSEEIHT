package allumettes;

/**
 * L'interface stratégie permet de définir les différentes stratégies que peut
 * adopter un joueur.
 *
 * @author Frenois Etan
 */

public interface Strategie {

    /**
     * Obtenir le nombre d'allumettes que prend un joueur pour un jeu donnée.
     *
     * @param jeu le jeu donné
     * @return le nombre d'allummettes
     */
    int getPrise(Jeu jeu);

}
