package allumettes;

/**
 * La stratégie tricheur consiste à retirer toutes les allumettes présentes et
 * en laisser que deux.
 *
 * @author Frenois Etan
 */
public class StrategieTricheur implements Strategie {

    @Override
    public int getPrise(Jeu jeu) {
        System.out.println("[Je triche...]");
        try {
            while (jeu.getNombreAllumettes() > 2) {
                jeu.retirer(1);
            }
            System.out.println("[Allumettes restantes : 2]");
        } catch (CoupInvalideException e) {
        }
        return 1;
    }

};
