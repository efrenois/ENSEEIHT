package allumettes;

/**
 * Cette classe reprsésente le jeu réel.
 *
 * @author Frenois Etan
 */

public class VraiJeu implements Jeu {

    private int nbAllumettes;

    /**
     * Construire un jeu avec un nombre d'allumettes données.
     *
     * @param nbAllumettes nombre d'allumettes données
     */
    public VraiJeu(int nbAllumettes) {
        this.nbAllumettes = nbAllumettes;
    }

    /**
     * Obtenir le nombre d'allumettes encore en jeu.
     *
     * @return nombre d'allumettes encore en jeu
     */
    @Override
    public int getNombreAllumettes() {
        return this.nbAllumettes;
    }

    /**
     * Retirer des allumettes. Le nombre d'allumettes doit être compris
     * entre 1 et PRISE_MAX, dans la limite du nombre d'allumettes encore
     * en jeu.
     *
     * @param nbPrises nombre d'allumettes prises.
     * @throws CoupInvalideException tentative de prendre un nombre invalide
     *                               d'allumettes
     */
    @Override
    public void retirer(int nbPrises) throws CoupInvalideException {
        if (nbPrises < 1) {
            throw new CoupInvalideException(nbPrises, "(< 1)");
        } else if (nbPrises > this.nbAllumettes) {
            throw new CoupInvalideException(nbPrises, "(>" + this.nbAllumettes + ")");
        } else if (nbPrises > PRISE_MAX && PRISE_MAX <= this.nbAllumettes) {
            throw new CoupInvalideException(nbPrises, "(>" + PRISE_MAX + ")");
        } else {
            this.nbAllumettes -= nbPrises;
        }
    }
}
