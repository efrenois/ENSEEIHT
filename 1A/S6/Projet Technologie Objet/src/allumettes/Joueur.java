package allumettes;

/**
 * La classe Joueur modélise un joueur. Un joueur a un nom. On peut demander à
 * un joueur le nombre d’allumettes qu’il veut prendre pour un jeu donné
 * (getPrise). Un joueur détermine le nombre d’allumettes à prendre en fonction
 * de sa stratégie : naïf, rapide, expert ou humain.
 *
 * @author Frenois Etan
 */

public class Joueur {

    /**
     * Nom du joueur
     */
    private String nom;

    /**
     * Stratégie choisit par le joueur
     */
    private Strategie strategie;

    /**
     * Construire un joueur avec son nom et la stratégie qu'il souhaite adopter.
     *
     * @param nom       nom du joueur
     * @param strat stratégie adoptée
     */
    public Joueur(String nom, Strategie strat) {
        this.nom = nom;
        this.strategie = strat;
    }

    /**
     * Obtenir le nom d'un joueur.
     *
     * @return le nom du joueur
     */
    public String getNom() {
        return this.nom;
    }

    /**
     * Obtenir le nombre d'allumettes que veut prendre le joueur pour un jeu donné.
     *
     * @param jeu jeu donné
     * @return le nombre d'allumettes
     */
    public int getPrise(Jeu jeu) {
        return this.strategie.getPrise(jeu);
    }
}
