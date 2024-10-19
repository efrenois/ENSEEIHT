package allumettes;

import java.util.Random;

/**
 * La stratégie naïf consiste à faire jouer l’ordinateur qui va choisir
 * aléatoirement un nombre entre 1 et PRISE_MAX.
 *
 * @author Frenois Etan
 */

public class StrategieNaif implements Strategie {

    @Override
    public int getPrise(Jeu jeu) {
        Random random = new Random();
        return random.nextInt(Jeu.PRISE_MAX) + 1;
    }
}
