#define _GNU_SOURCE
#include "liste_noeud.h"
#include <stdlib.h>
#include <math.h>

// Type interne _cellule qui représente une cellule
typedef struct cellule {
    noeud_id_t noeud;
    noeud_id_t precedent;
    double distance;
    struct cellule* cellule_suivante;
} _cellule;

// Type abstrait liste_noeud_t
struct liste_noeud_t {
    _cellule* cellule_tete;
};

liste_noeud_t* creer_liste() {
    liste_noeud_t* liste = (liste_noeud_t *)malloc(sizeof(liste_noeud_t));
    liste->cellule_tete = NULL;
    return liste;
}

void detruire_liste(liste_noeud_t** liste_ptr) {   
    _cellule* cellule_courante = (*liste_ptr)->cellule_tete;
    while (cellule_courante != NULL) {
        _cellule* cellule_aux = cellule_courante;
        cellule_courante = cellule_courante->cellule_suivante;
        free(cellule_aux); 
    }
    free(*liste_ptr); 
    *liste_ptr = NULL; 
}

bool est_vide_liste(const liste_noeud_t* liste) {
    return liste->cellule_tete == NULL;
}

bool contient_noeud_liste(const liste_noeud_t* liste, noeud_id_t noeud) {
    _cellule* cellule_courante = liste->cellule_tete;
    while (cellule_courante != NULL) {
        if (cellule_courante->noeud == noeud) {
            return true;
        }
        cellule_courante = cellule_courante->cellule_suivante;
    }
    return false;
}

bool contient_arrete_liste(const liste_noeud_t* liste, noeud_id_t source, noeud_id_t destination) {
    _cellule* cellule_courante = liste->cellule_tete;
    while (cellule_courante != NULL) {
        if (cellule_courante->noeud == destination && cellule_courante->precedent == source) {
            return true;
        }
        cellule_courante = cellule_courante->cellule_suivante;
    }
    return false;
}

double distance_noeud_liste(const liste_noeud_t* liste, noeud_id_t noeud) {
    _cellule* cellule_courante = liste->cellule_tete;
    while (cellule_courante != NULL) {
        if (cellule_courante->noeud == noeud) {
            return cellule_courante->distance;
        }
        cellule_courante = cellule_courante->cellule_suivante;
    }
    return INFINITY;
}

noeud_id_t precedent_noeud_liste(const liste_noeud_t* liste, noeud_id_t noeud) {
    _cellule* cellule_courante = liste->cellule_tete;
    while (cellule_courante != NULL) {
        if (cellule_courante->noeud == noeud) {
            return cellule_courante->precedent;
        }
        cellule_courante = cellule_courante->cellule_suivante;
    }
    return NO_ID;
}

noeud_id_t min_noeud_liste(const liste_noeud_t* liste) {
    if (est_vide_liste(liste)) {
        return NO_ID;
    } else {
        _cellule* cellule_courante = liste->cellule_tete;
        double distance_min = cellule_courante->distance;
        noeud_id_t noeud_min = cellule_courante->noeud;
        while (cellule_courante != NULL) {
            if (cellule_courante->distance < distance_min) {
                distance_min =cellule_courante->distance;
                noeud_min = cellule_courante->noeud;
            }
            cellule_courante = cellule_courante->cellule_suivante;
        }
        return noeud_min;
    }
}

void inserer_noeud_liste(liste_noeud_t* liste, noeud_id_t noeud, noeud_id_t precedent, double distance) {
    if (est_vide_liste(liste)) {
        _cellule* nouvelle_cellule = (_cellule*)malloc(sizeof(_cellule));
        nouvelle_cellule->noeud = noeud;
        nouvelle_cellule->distance = distance;
        nouvelle_cellule->precedent = precedent;
        nouvelle_cellule->cellule_suivante = NULL; 
        liste->cellule_tete = nouvelle_cellule;
    } else {
        _cellule* cellule_courante = liste->cellule_tete;
        while (cellule_courante->cellule_suivante != NULL) {
            cellule_courante = cellule_courante->cellule_suivante;
        }
        _cellule* nouvelle_cellule = (_cellule*)malloc(sizeof(_cellule));
        nouvelle_cellule->noeud = noeud;
        nouvelle_cellule->distance = distance;
        nouvelle_cellule->precedent = precedent;
        nouvelle_cellule->cellule_suivante = NULL;
        cellule_courante->cellule_suivante = nouvelle_cellule;
    } 
}

void changer_noeud_liste(liste_noeud_t* liste, noeud_id_t noeud, noeud_id_t precedent, double distance) {
    if (!contient_noeud_liste(liste,noeud)) {
        inserer_noeud_liste(liste, noeud, precedent, distance);
    } else {
        _cellule* cellule_courante = liste->cellule_tete;
        while (cellule_courante != NULL) {
            if (cellule_courante->noeud == noeud) {
                cellule_courante->precedent = precedent;
                cellule_courante->distance = distance;
            }
            cellule_courante = cellule_courante->cellule_suivante;
        }
    }
}

void supprimer_noeud_liste(liste_noeud_t* liste, noeud_id_t noeud) {
    if (est_vide_liste(liste)) {
        NULL;
    } else if (liste->cellule_tete->noeud == noeud) {
        _cellule* cellule_aux = liste->cellule_tete;
        liste->cellule_tete = liste->cellule_tete->cellule_suivante;
        free(cellule_aux);               
    } else {
        _cellule* cellule_precedente = liste->cellule_tete;
        _cellule* cellule_courante = cellule_precedente->cellule_suivante;
        while (contient_noeud_liste(liste, noeud)) {
            if (cellule_courante->noeud == noeud) {
                cellule_precedente->cellule_suivante = cellule_courante->cellule_suivante;
                free(cellule_courante);
                break;
            }
            cellule_precedente = cellule_courante;
            cellule_courante = cellule_courante->cellule_suivante;
        }
    }
 
}
