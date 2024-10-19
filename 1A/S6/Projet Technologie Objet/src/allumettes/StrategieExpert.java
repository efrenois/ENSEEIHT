package allumettes;

/**
 * La stratégie expert consiste à ce que l’ordinateur joue du mieux qu’il peut
 * (s’il peut gagner, il gagnera).
 *
 * @author Frenois Etan
 */

public class StrategieExpert implements Strategie {

    @Override
    public int getPrise(Jeu jeu) {
        int prise;
        if ((jeu.getNombreAllumettes() - Jeu.PRISE_MAX) % (Jeu.PRISE_MAX + 1) == 1) {
            prise = Jeu.PRISE_MAX;
        } else if ((jeu.getNombreAllumettes() - 2) % (Jeu.PRISE_MAX + 1) == 1) {
            prise = Jeu.PRISE_MAX - 1;
        } else {
            prise = 1;
        }
        return prise;
    }

}
