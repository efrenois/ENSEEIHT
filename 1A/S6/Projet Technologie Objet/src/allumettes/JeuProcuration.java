package allumettes;

/**
 * La classe JeuProcuration joue le rôle de proxy.
 *
 * @author Frenois Etan
 */

public class JeuProcuration implements Jeu {

    /*
     * Jeu qui va devenir le jeu proxy.
     */
    private Jeu jeu;

    /**
     * Construire la porcuration.
     *
     * @param jeu jeu qui va devenir le jeu proxy
     */
    public JeuProcuration(Jeu jeu) {
        this.jeu = jeu;
    }

    public int getNombreAllumettes() {
        return this.jeu.getNombreAllumettes();
    }

    public void retirer(int nbPrises) throws CoupInvalideException {
        throw new OperationInterditeException("[Je triche...]");
    }

}
