package allumettes;

/**
 * Cette strategie consiste à ce que l’ordinateur prenne le maximum d’allumettes
 * possible (de manière à ce que la partie se termine le plus rapidement
 * possible).
 *
 * @author Frenois Etan
 */

public class StrategieRapide implements Strategie {

    @Override
    public int getPrise(Jeu jeu) {
        if (jeu.getNombreAllumettes() > Jeu.PRISE_MAX) {
            return Jeu.PRISE_MAX;
        } else {
            return jeu.getNombreAllumettes();
        }
    }

}
