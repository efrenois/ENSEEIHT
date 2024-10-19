package allumettes;

/**
 * Lance une partie des 13 allumettes en fonction des arguments fournis
 * sur la ligne de commande.
 *
 * @author Xavier Crégut
 * @version $Revision: 1.5 $
 */
public class Jouer {

	/**
	 * Nombre d'allumettes au départ de la partie.
	 */
	private static final int NB_ALLUMETTES_INITIAL = 13;

	/**
	 * Récupère la stratégie entrée en ligne de commande pour la transformer en type
	 * "Strategie".
	 *
	 * @param strategieJoueur stratégie définie par l'utilisateur
	 * @return la stratégie définie par l'utilisateur et la convertie en type
	 *         "Strategie"
	 */
	public static Strategie getStrategie(String strategieJoueur, String nomJoueur) {
		Strategie strategie;
		switch (strategieJoueur) {
			case "humain":
				strategie = new StrategieHumain(nomJoueur);
				break;
			case "naif":
				strategie = new StrategieNaif();
				break;
			case "rapide":
				strategie = new StrategieRapide();
				break;
			case "expert":
				strategie = new StrategieExpert();
				break;
			case "tricheur":
				strategie = new StrategieTricheur();
				break;
			case "lente":
				strategie = new StrategieLente();
				break;
			default:
				throw new ConfigurationException("");
		}
		return strategie;
	}

	/**
	 * Créer un joueur avec son nom et sa stratégie.
	 *
	 * @param descriptionJoueur
	 * @return un joueur avec son nom et sa stratégie
	 */
	public static Joueur creerJoueur(String descriptionJoueur) {
		String[] descriptionJoueurTab = descriptionJoueur.split("@");
		if (descriptionJoueurTab.length >= 2) {
			String nomJoueur = descriptionJoueurTab[0];
			String strategieJoueur = descriptionJoueurTab[1];
			return new Joueur(nomJoueur, getStrategie(strategieJoueur, nomJoueur));
		} else {
			throw new ConfigurationException("");
		}
	}

	/**
	 * Lancer une partie. En argument sont donnés les deux joueurs sous
	 * la forme nom@stratégie.
	 *
	 * @param args la description des deux joueurs
	 */
	public static void main(String[] args) {

		try {
			verifierNombreArguments(args);
			Jeu jeu = new VraiJeu(NB_ALLUMETTES_INITIAL);
			boolean confiant = false;
			String premierArg; // Premier argument de la ligne de commande.
			String deuxiemeArg; // Second argument de la ligne de commande.

			// On traite la ligne de commande dans le cas où il y'a trois arguments
			// avec le premier qui est "-confiant" ou dans le cas où il y'a que
			// deux arguments de la forme nom@stratégie.
			if (args.length == Jeu.PRISE_MAX) {
				confiant = args[0].equals("-confiant");
				premierArg = args[1];
				deuxiemeArg = args[2];
			} else if (args.length == 2) {
				premierArg = args[0];
				deuxiemeArg = args[1];
			} else {
				throw new ConfigurationException("");
			}

			Joueur j1 = creerJoueur(premierArg); // Initialisation du premier joueur
			Joueur j2 = creerJoueur(deuxiemeArg); // Initialisation du second joueur

			// Construire un arbitre et arbitrer la partie en j1 et j2.
			Arbitre arbitre = new Arbitre(j1, j2);
			arbitre.estConfiant(confiant);
			arbitre.arbitrer(jeu);

		} catch (ConfigurationException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
			System.exit(1);
		}
	}

	private static void verifierNombreArguments(String[] args) {
		final int nbJoueurs = 2;
		if (args.length < nbJoueurs) {
			throw new ConfigurationException("Trop peu d'arguments : "
					+ args.length);
		}
		if (args.length > nbJoueurs + 1) {
			throw new ConfigurationException("Trop d'arguments : "
					+ args.length);
		}
	}

	/** Afficher des indications sur la manière d'exécuter cette classe. */
	public static void afficherUsage() {
		System.out.println("\n" + "Usage :"
				+ "\n\t" + "java allumettes.Jouer joueur1 joueur2"
				+ "\n\t\t" + "joueur est de la forme nom@stratégie"
				+ "\n\t\t" + "strategie = naif | rapide | expert | humain | tricheur"
				+ "\n"
				+ "\n\t" + "Exemple :"
				+ "\n\t" + "	java allumettes.Jouer Xavier@humain "
				+ "Ordinateur@naif"
				+ "\n");
	}

}
