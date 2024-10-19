package allumettes;

/**
 * Stratégie qui consiste à prendre une allumettes à chaque fois.
 *
 * @author Frenois Etan
 */
public class StrategieLente implements Strategie {

    @Override
    public int getPrise(Jeu jeu) {
        return 1;
    }


}
