#include "complexe.h"
#include <math.h> // Pour certaines fonctions trigo notamment


// Implantations de reelle et imaginaire
double reelle(complexe_t c) {
    return c.pr;
}

double imaginaire(complexe_t c) {
    return c.pi;
}

// Implantations de set_reelle et set_imaginaire
void set_reelle(complexe_t *c, double nouvelle_pr) {
    c->pr = nouvelle_pr;
}

void set_imaginaire(complexe_t *c, double nouvelle_pi) {
    c->pi = nouvelle_pi;
}

// Implantations de init
void init (complexe_t *c, double nouvelle_pr, double nouvelle_pi) {
    set_reelle(c,nouvelle_pr);
    set_imaginaire(c,nouvelle_pi);
}

// Implantation de copie
void copie(complexe_t *resultat, complexe_t autre) {
    init(resultat, autre.pr,autre.pi );
}

// Implantations des fonctions algébriques sur les complexes
void conjugue(complexe_t *resultat, complexe_t op) {
    set_imaginaire(&op, -imaginaire(op));
    copie(resultat, op);
}

void ajouter(complexe_t *resultat, complexe_t gauche, complexe_t droite) {
    //(*resultat).pr = gauche.pr + droite.pr;
    //(*resultat).pi = gauche.pi + droite.pi;
    init(resultat, reelle(gauche)+reelle(droite), imaginaire(gauche)+imaginaire(droite));
}

void soustraire(complexe_t *resultat, complexe_t gauche, complexe_t droite) {
init(resultat, reelle(gauche)-reelle(droite), imaginaire(gauche)-imaginaire(droite));
}

void multiplier(complexe_t *resultat, complexe_t gauche, complexe_t droite) {
    init(resultat, reelle(gauche)*reelle(droite)-imaginaire(gauche)*imaginaire(droite),reelle(gauche)*imaginaire(droite)+imaginaire(gauche)*reelle(droite));
}

void echelle(complexe_t *resultat, complexe_t op, double facteur) {
    init(resultat, facteur*reelle(op), facteur*imaginaire(op));
}

void puissance(complexe_t *resultat, complexe_t op, int exposant){
    if (exposant == 0){
        init(resultat, 1.0, 0.0);
        } else {
            init(resultat, 1.0, 0.0);
            for (int i=0; i<exposant;i++){
                multiplier(resultat,*resultat,op);
            }
        }

}

// Implantations du module et de l'argument
double module_carre (complexe_t c) {
    return (reelle(c)*reelle(c) + imaginaire(c)*imaginaire(c));
}

double module (complexe_t c) {
    return sqrt(module_carre(c));
}

double argument (complexe_t c) {
    return atan2(imaginaire(c),reelle(c));
}
