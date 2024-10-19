package allumettes;

/**
 * La classe Arbitre fait respecter les règles du jeu aux deux joueurs. Cette
 * classe possède un constructeur qui prend en paramètre les deux joueurs j1 et
 * j2 qui vont s’affronter. Une (et une seule) partie peut alors être arbitrée
 * entre ces deux joueurs. L’arbitre fait jouer, à tour de rôle, chaque joueur
 * en commençant par le joueur j1. Celui qui prend la dernière allumette a
 * perdu. Faire jouer un joueur consiste à afficher le nombre d’allumettes
 * encore en jeu, lui demander le nombre d’allumettes qu’il souhaite prendre,
 * afficher ce nombre, puis à retirer les allumettes du jeu. Si ceci provoque
 * une violation des règles du jeu (exception CoupInvalideException), le même
 * joueur devra rejouer.
 *
 * @author Frenois Etan
 */

public class Arbitre {

    /**
     * Le premier joueur du jeu.
     */
    private Joueur joueur1;

    /**
     * Le second joueur du jeu.
     */
    private Joueur joueur2;

    /**
     * Savoir si l'arbitre est confiant
     */
    private boolean confiant;

    /**
     * On construit un arbitre avec deux joueurs qui vont s'affronter.
     *
     * @param j1 premier joueur
     * @param j2 second joueur
     */
    public Arbitre(Joueur j1, Joueur j2) {
        this.joueur1 = j1;
        this.joueur2 = j2;
    }

    /**
     * Passer la main à l'autre joueur.
     *
     * @param change booléen qui permet le changement de tour
     * @return le joueur actuel
     */
    public Joueur changementJoueur(boolean change) {
        Joueur joueur = this.joueur1;
        if (change) {
            joueur = this.joueur1;
        } else {
            joueur = this.joueur2;
        }
        return joueur;
    }

    /**
     * Arbitrer une partie.
     *
     * @param jeu jeu à arbitrer
     */
    public void arbitrer(Jeu jeu) {
        boolean change = true; // booléen permettant de changer de joueur
        Joueur joueur = changementJoueur(change); // Joueur actuel
        Joueur joueurGagnant; // Joueur victorieux
        int nbPrises;
        boolean tricheDetectee = false; // booléen permettant de detecter la triche

        while (jeu.getNombreAllumettes() > 0 && !tricheDetectee) {
            try {

                joueur = changementJoueur(change);
                System.out.println("Allumettes restantes : " + jeu.getNombreAllumettes());

                if (confiant) {
                    nbPrises = joueur.getPrise(jeu);
                } else {
                    // Jeu avec la procuration
                    Jeu jeuProcuration = new JeuProcuration(jeu);
                    nbPrises = joueur.getPrise(jeuProcuration);
                }

                afficherJoueurPrise(nbPrises, joueur);
                jeu.retirer(nbPrises);
                change = !change;
                System.out.println("");

            } catch (CoupInvalideException e) {
                System.out.println("Impossible ! Nombre invalide : "
                        + e.getCoup() + " " + e.getProbleme() + "\n");
            } catch (OperationInterditeException e) {
                System.out.println("Abandon de la partie car "
                        + joueur.getNom() + " triche !");
                tricheDetectee = true;
            }
        }

        // Identification du joueur gagnant
        if (!tricheDetectee) {
            System.out.println(joueur.getNom() + " perd !");
            joueurGagnant = changementJoueur(change);
            System.out.println(joueurGagnant.getNom() + " gagne !");
        }
    }

    /**
     * Mettre l'arbitre en mode confiant.
     *
     * @param confiance
     * @return un booléen qui décrit l'arbitre comme confiant
     */
    public boolean estConfiant(boolean confiance) {
        this.confiant = confiance;
        return this.confiant;
    }

    /**
     * Afficher la prise du joueur courant.
     *
     * @param nbPrises nombre d'allumettes prises
     * @param joueur   joueur courant
     */
    public void afficherJoueurPrise(int nbPrises, Joueur joueur) {
        if (nbPrises <= 1) {
            System.out.println(
                    joueur.getNom() + " prend " + nbPrises + " allumette.");

        } else {
            System.out.println(
                    joueur.getNom() + " prend " + nbPrises + " allumettes.");
        }
    }
}
