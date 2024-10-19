package allumettes;

import java.util.Scanner;

/**
 * La stratégie humain consiste à demander à l’utilisateur le nombre
 * d'allumettes qu'il souhaite prendre.
 * Ceci permet d’avoir un joueur humain.
 *
 * @author Frenois Etan
 */

public class StrategieHumain implements Strategie {

    private static Scanner scanner = new Scanner(System.in);
    private String nomJoueur;

    /**
     * Constructeur de la classe stratégie humain
     */
    public StrategieHumain(String nomJoueur) {

        this.nomJoueur = nomJoueur;
    }

    // On laisse le choix à l'utilisateur de choisir le nombre d'allumettes qu'il
    // souhaite prendre.
    @Override
    public int getPrise(Jeu jeu) {
        boolean estPrise = true;
        while (estPrise) {
            System.out.print(nomJoueur + ", combien d'allumettes ? ");
            try {
                String entree = scanner.nextLine(); // entrée lu au clavier
                if (entree.equals("triche")) {
                    try {
                        System.out.println(
                                "[Une allumette en moins, plus que "
                                        + (jeu.getNombreAllumettes() - 1) + ". Chut !]");
                        jeu.retirer(1);
                    } catch (CoupInvalideException e) {
                    }
                } else {
                    int nombrePrise = Integer.parseInt(entree);
                    estPrise = false;
                    return nombrePrise;
                }
            } catch (NumberFormatException e) {
                System.out.println("Vous devez donner un entier.");
            }
        }
        return 0;
    }

}
