#ifndef COMPLEX_H
#define COMPLEX_H

// Type utilisateur complexe_t
struct complexe_t {
    double pr;
    double pi;
};
typedef struct complexe_t complexe_t ;

// Fonctions reelle et imaginaire
/**
 * reelle
 * Associe à un nombre complexe sa partie réelle.
 *
 * Paramètres:
 * c            [in] nombre complexe dont on veut la partie réelle.
 *
 * Pré-conditions : c non-null
 * Post-conditions : c.pr non-null 
 *
 * Retour : c.pr, défini par RE(c) = c.pr 
 * Cas d'erreur : aucun
 */
/** FONCTION À DÉCLARER **/
double reelle(complexe_t c);

/**
 * imaginaire
 * Associe à un nombre complece sa partie imaginaire
 *
 * Paramètres:
 * c           [in] nombre complexe dont on veut la partie imaginaire.
 *
 * Pré-conditions : c non-null 
 * Post-conditions : c.pi non-null 
 *
 * Retour : c.pi, défini par IM(c) = c.pi 
 * Cas d'erreur : aucun
 * 
 */
/** FONCTION À DÉCLARER **/
double imaginaire(complexe_t c);

// Procédures set_reelle, set_imaginaire et init
/**
 * set_reelle
 * Modifie la partie réelle du nombre complexe donné avec le nombre réel donné (dans cet ordre).
 * 
 * Paramètres:
 * *c           [out] Nombre complexe dont on modifie la partie réelle.
 * nouvelle_pr  [in]  Nouvelle partie réelle du nombre complexe donnée.
 *
 * Pré-conditions : *c non-null 
 * Post-conditions : reelle(*c) = nouvelle_pr 
 *
 *
 * Cas d'erreur : aucun
 */
/** PROCÉDURE À DÉCLARER **/
void set_reelle (complexe_t *c , double nouvelle_pr);

/**
 * set_imaginaire
 * Modifie la partie imaginaire du nombre complexe donné avec le nombre réel donné (dans cet ordre).
 *
 * Paramètres:
 * *c           [out] Nombre complexe dont on modifie la partie imaginaire.
 * nouvelle_pi  [in]  Nouvelle partie imaginaire du nombre complexe donnée.
 *
 * Pré-conditions : *c non-null 
 * Post-conditions : imaginaire(*c) = nouvelle_pi
 *
 *
 * Cas d'erreur : aucun
 */
/** PROCÉDURE À DÉCLARER **/
void set_imaginaire (complexe_t *c, double nouvelle_pi);

/**
 * init
 * Modifie la partie réelle et la partie imaginaire du nombre complexe donné avec les deux réels donnés (partie réelle puis imaginaire, dans cet ordre)
 *
 * Paramètres:
 * 
 * *c           [out] Nombre complexe dont on modifie la partie réelle et imaginaire. 
 * nouvelle_pr  [in]  Nouvelle partie réelle du nombre complexe donnée.
 * nouvelle_pi  [in]  Nouvelle partie imaginaire du nombre complexe donnée.
 *
 * Pré-conditions : *c non-null 
 * Post-conditions : reelle(*c)= nouvelle_pr et imaginaire(*c) = nouvelle_pi 
 *
 *
 * Cas d'erreur : aucun
 */
/** PROCÉDURE À DÉCLARER **/
void init (complexe_t *c, double nouvelle_pr, double nouvelle_pi);

// Procédure copie
/**
 * copie
 * Copie les composantes du complexe donné en second argument dans celles du premier
 * argument
 *
 * Paramètres :
 *   resultat       [out] Complexe dans lequel copier les composantes
 *   autre          [in]  Complexe à copier
 *
 * Pré-conditions : resultat non null
 * Post-conditions : resultat et autre ont les mêmes composantes
 */
void copie(complexe_t *resultat, complexe_t autre);

// Algèbre des nombres complexes
/**
 * conjugue
 * Calcule le conjugué du nombre complexe op et le stocke dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   op             [in]  Complexe dont on veut le conjugué
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : reelle(*resultat) = reelle(op), complexe(*resultat) = - complexe(op)
 */
void conjugue(complexe_t *resultat, complexe_t op);

/**
 * ajouter
 * Réalise l'addition des deux nombres complexes gauche et droite et stocke le résultat
 * dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   gauche         [in]  Opérande gauche
 *   droite         [in]  Opérande droite
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = gauche + droite
 */
void ajouter(complexe_t *resultat, complexe_t gauche, complexe_t droite);

/**
 * soustraire
 * Réalise la soustraction des deux nombres complexes gauche et droite et stocke le résultat
 * dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   gauche         [in]  Opérande gauche
 *   droite         [in]  Opérande droite
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = gauche - droite
 */
void soustraire(complexe_t *resultat, complexe_t gauche, complexe_t droite);

/**
 * multiplier
 * Réalise le produit des deux nombres complexes gauche et droite et stocke le résultat
 * dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   gauche         [in]  Opérande gauche
 *   droite         [in]  Opérande droite
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = gauche * droite
 */
void multiplier(complexe_t *resultat, complexe_t gauche, complexe_t droite);

/**
 * echelle
 * Calcule la mise à l'échelle d'un nombre complexe avec le nombre réel donné (multiplication
 * de op par le facteur réel facteur).
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   op             [in]  Complexe à mettre à l'échelle
 *   facteur        [in]  Nombre réel à multiplier
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = op * facteur
 */
void echelle(complexe_t *resultat, complexe_t op, double facteur);

/**
 * puissance
 * Calcule la puissance entière du complexe donné et stocke le résultat dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   op             [in]  Complexe dont on veut la puissance
 *   exposant       [in]  Exposant de la puissance
 *
 * Pré-conditions : resultat non-null, exposant >= 0
 * Post-conditions : *resultat = op * op * ... * op
 *                                 { n fois }
 */
void puissance(complexe_t *resultat, complexe_t op, int exposant);

// Module et argument
/**
 * module_carre
 * Calcule le carré du module du complexe donné en paramètre
 *
 * Paramètres :
 *   c       [in] Nombre complexe dont on veut calculer le module carrée
 *
 *
 * Pré-conditions : c non-null
 * Post-conditions : module carré de c >= 0 
 * 
 * Retour : Re(c)*Re(c) + Im(c)*Im(c)
 */
double module_carre (complexe_t c);

/**
 * module
 * Calcule le module du complexe donné en paramètre
 *
 * Paramètres :
 *   c       [in] Nombre complexe dont on veut calculer le module
 *
 *
 * Pré-conditions : c non-null
 * Post-conditions : module de c >= 0 et sqrt(module_carre(c)) = module(c)
 * 
 * Retour : ||c||
 */
double module (complexe_t c);

/**
 * argument
 * Calcule l’argument du complexe donné en paramètre
 *
 * Paramètres :
 *   c       [in] Nombre complexe dont on veut calculer le module
 *
 *
 * Pré-conditions : Re(c) non-null
 * Post-conditions :  -pi < Arg(c) =< pi 
 * 
 * Retour : Arg(c)
 */
double argument (complexe_t c);

#endif // COMPLEXE_H
