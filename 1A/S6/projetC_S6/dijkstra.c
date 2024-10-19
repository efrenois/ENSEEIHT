#include "dijkstra.h"
#include <stdlib.h>

/**
 * construire_chemin_vers - Construit le chemin depuis le noeud de départ donné vers le
 * noeud donné. On passe un chemin en entrée-sortie de la fonction, qui est mis à jour
 * par celle-ci.
 *
 * Le noeud de départ est caractérisé par un prédécesseur qui vaut `NO_ID`.
 *
 * Ce sous-programme fonctionne récursivement :
 *  1. Si le noeud a pour précédent `NO_ID`, on a fini (c'est le noeud de départ, le chemin de
 *     départ à départ se compose du simple noeud départ)
 *  2. Sinon, on construit le chemin du départ au noeud précédent (appel récursif)
 *  3. Dans tous les cas, on ajoute le noeud au chemin, avec les caractéristiques associées dans visites
 *
 * @param chemin [in/out] chemin dans lequel enregistrer les étapes depuis le départ vers noeud
 * @param visites [in] liste des noeuds visités créée par l'algorithme de Dijkstra
 * @param noeud noeud vers lequel on veut construire le chemin depuis le départ
 */
void construire_chemin_vers(liste_noeud_t* chemin, const liste_noeud_t* visites, noeud_id_t noeud) {
    //(C-1)
    noeud_id_t noeud_p = precedent_noeud_liste(visites, noeud);
    //(C-2)
    if (noeud_p != NO_ID) {
        //(C-3.1)
        construire_chemin_vers(chemin, visites, noeud_p);
    }
    //(C-3.2)
    inserer_noeud_liste(chemin, noeud, noeud_p, distance_noeud_liste(visites, noeud));
}


float dijkstra(
    const struct graphe_t* graphe, 
    noeud_id_t source, noeud_id_t destination, 
    liste_noeud_t** chemin) {

    liste_noeud_t* a_visiter = creer_liste();  // Liste des noeuds à visiter 
    liste_noeud_t* visites = creer_liste();    // Liste des noeuds déjà visités 

    //(D-1)
    inserer_noeud_liste(a_visiter, source, NO_ID, 0); 
    
    //(D-2)
    while (!est_vide_liste(a_visiter)) {
        //(D-2.1)
        noeud_id_t noeud_courant = min_noeud_liste(a_visiter);
        //(D-2.2)
        inserer_noeud_liste(visites, noeud_courant, precedent_noeud_liste(a_visiter, noeud_courant), distance_noeud_liste(a_visiter, noeud_courant));
        //(D-2.3)
        supprimer_noeud_liste(a_visiter, noeud_courant);
        //(D-2.4)
        size_t nvoisins = nombre_voisins(graphe, noeud_courant);
        noeud_id_t* voisins = (noeud_id_t*)malloc(nvoisins*sizeof(noeud_id_t)); 
        noeuds_voisins(graphe, noeud_courant, voisins);

        for (size_t i = 0; i < nvoisins; i++) {
            noeud_id_t noeud_v = voisins[i];

            if (!contient_noeud_liste(visites, noeud_v)) {
                //(D-2.4.1)
                float delta_prime = distance_noeud_liste(visites, noeud_courant) + noeud_distance(graphe, noeud_courant, noeud_v);
                //(D-2.4.2)
                float delta = distance_noeud_liste(a_visiter, noeud_v);
                //(D-2.4.3)
                if (delta_prime < delta) {
                    changer_noeud_liste(a_visiter, noeud_v, noeud_courant, delta_prime);
                }
            }
        }
        free(voisins);
        voisins = NULL;
    } 

    if (chemin != NULL) {
        // Construction du chemin
        *chemin = creer_liste();
        construire_chemin_vers(*chemin, visites, destination);
    } 
 

    // Calcul du chemin le plus court
    double distance_minimale = distance_noeud_liste(visites, destination);

    // Libération mémoire
    detruire_liste(&a_visiter);
    detruire_liste(&visites);


    
    return distance_minimale;

}



