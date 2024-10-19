#include <stdio.h>
#include <stdlib.h>
#include "readcmd.h"
#include <stdbool.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <signal.h>
#include <sys/stat.h>
#include <fcntl.h>

static void traitement(int sig)
{
    if (sig == SIGCHLD)
    {
        int status;
        int pid_fils;
        while ((pid_fils = waitpid(-1, &status, WNOHANG | WUNTRACED | WCONTINUED)) > 0)
        {
            if (WIFEXITED(status))
            {
                printf("\n Un processecus fils %d vient de finir avec le signal %d \n", pid_fils, sig);
            }
            else if (WIFSIGNALED(status))
            {
                printf(" \n Le processus fils %d s'est terminé avec le signal %d\n", pid_fils, sig);
            }
            else if (WIFSTOPPED(status))
            {
                printf("\n Le processus fils %d s'est suspendu à cause du signal %d\n", pid_fils, sig);
            }
            else if (WIFCONTINUED(status))
            {
                printf("\n Le processus fils %d a repris \n", pid_fils);
            }
        }
        // Traitement signaux SIGINT & SIGTSTP (13.1)
    }
    else if (sig == SIGINT)
    {
        printf(" Un crtl-C vient d'avoir lieu  \n ");
    }
    else if (sig == SIGTSTP)
    {
        printf(" Un crtl-Z vient d'avoir lieu \n ");
    }
}

int set_signal(int sig, void (*traitement)(int))
{
    struct sigaction action;
    action.sa_handler = traitement;
    sigemptyset(&action.sa_mask);
    action.sa_flags = SA_RESTART;
    return sigaction(sig, &action, NULL);
}

int main(void)
{

    set_signal(SIGCHLD, traitement);

    // Traitement signaux SIGINT & SIGTSTP (On les ignore)
    set_signal(SIGINT, SIG_IGN);
    set_signal(SIGTSTP, SIG_IGN);

    // Masquage des signaux SIGINT & SIGTSTP
    sigset_t masque;
    sigemptyset(&masque);
    sigaddset(&masque, SIGINT);
    sigaddset(&masque, SIGTSTP);
    sigprocmask(SIG_BLOCK, &masque, NULL);

    bool fini = false;

    while (!fini)
    {
        printf("> ");
        struct cmdline *commande = readcmd();

        if (commande == NULL)
        {
            // commande == NULL -> erreur readcmd()
            perror("erreur lecture commande \n");
            exit(EXIT_FAILURE);
        }
        else
        {

            if (commande->err)
            {
                // commande->err != NULL -> commande->seq == NULL
                printf("erreur saisie de la commande : %s\n", commande->err);
            }
            else
            {
                int indexseq = 0;
                char **cmd;
                char **test;
                if ((cmd = commande->seq[indexseq]))
                {
                    if (cmd[0])
                    {
                        if (strcmp(cmd[0], "exit") == 0)
                        {
                            fini = true;
                            printf("Au revoir ...\n");
                        }
                        else
                        {

                            if ((test = commande->seq[indexseq + 1]))
                            {
                                // Cas où la commande est composée de plusieurs commandes séparées par |
                                // Index de parcours de la commande
                                int i = 0;

                                // Initialisation tube
                                int tube_entree = 0;
                                int tube[2];

                                // On boucle sur les commandes
                                while (commande->seq[i] != NULL)
                                {
                                    // S'il y a une commande en suivant, création du tube
                                    if (commande->seq[i + 1] != NULL)
                                    {
                                        if (pipe(tube) == -1)
                                        {
                                            perror("Erreur  création du tube");
                                            exit(EXIT_FAILURE);
                                        }
                                    }
                                    else
                                    {
                                        // Redirection écriture du tube vers la sortie du terminal */
                                        tube[1] = STDOUT_FILENO;
                                    }

                                    // Création du fils
                                    pid_t pid = fork();

                                    if (pid == -1)
                                    {

                                        perror("Erreur fork");
                                        exit(EXIT_FAILURE);
                                    }
                                    else if (pid == 0)
                                    { // fils
                                        // Si ce n'est pas la première commande, on prend l'entrée dans le tube d'avant
                                        if (tube_entree != STDIN_FILENO)
                                        {
                                            dup2(tube_entree, STDIN_FILENO);
                                            close(tube_entree);
                                        }
                                        // Si ce n'est pas la dernière commande, on donne la sortie au tube d'après
                                        if (tube[1] != STDOUT_FILENO)
                                        {
                                            dup2(tube[1], STDOUT_FILENO);
                                            close(tube[1]);
                                        }
                                        // Fermeture lecture du tube courant
                                        close(tube[0]);

                                        // Lancement commande
                                        execvp(commande->seq[i][0], commande->seq[i]);
                                        perror("Impossible de réaliser la commande souhaitée");
                                        exit(EXIT_FAILURE);
                                    }
                                    else
                                    { // père
                                        // Attente de la fin du fils
                                        wait(NULL);
                                        if (tube_entree != STDIN_FILENO)
                                        {
                                            // Fin lecture
                                            close(tube_entree);
                                        }
                                        if (tube[1] != STDOUT_FILENO)
                                        {
                                            /* Fin écriture */
                                            close(tube[1]);
                                        }
                                        // Actualisation de l'entrée pour la prochaine commande
                                        tube_entree = tube[0];
                                    }
                                    i++;
                                }
                            }
                            else
                            {
                                // Cas où il n'y a qu'une seule commande
                                pid_t pid_fils;
                                pid_fils = fork();
                                if (pid_fils == -1)
                                {
                                    exit(EXIT_FAILURE);
                                }
                                else if (pid_fils == 0)
                                {                                            // fils
                                    set_signal(SIGINT, SIG_DFL);             // 13.2 retour du traitement par défaut 
                                    set_signal(SIGTSTP, SIG_DFL);            // 13.2 retour du traitement par défaut 
                                    sigprocmask(SIG_UNBLOCK, &masque, NULL); // 13.3
                                    if (commande->in != NULL)
                                    {
                                        int desc_source;
                                        if ((desc_source = open(commande->in, O_RDONLY)) == -1)
                                        {
                                            perror("erreur de la source\n");
                                            exit(EXIT_FAILURE);
                                        }
                                        dup2(desc_source, 0); // remplacer source
                                        close(desc_source);
                                    }

                                    if (commande->out != NULL)
                                    {
                                        int desc_destination;
                                        if ((desc_destination = open(commande->out, O_CREAT | O_WRONLY | O_TRUNC, 0666)) == -1)
                                        {
                                            perror("erreur destination\n");
                                            exit(EXIT_FAILURE);
                                        }
                                        dup2(desc_destination, 1); // remplacer destination
                                        close(desc_destination);
                                    }
                                    if (commande->backgrounded != NULL)
                                    {
                                        setpgrp(); // 14
                                    }
                                    if (execvp(cmd[0], cmd) == -1)
                                    {
                                        exit(EXIT_FAILURE);
                                    }
                                    else
                                    {
                                        exit(EXIT_SUCCESS);
                                    }
                                }
                                else
                                {
                                    /*père*/
                                    if (commande->backgrounded == NULL)
                                    {
                                        pause();
                                    }
                                }
                                printf("\n");
                            }
                        }
                    }
                }
            }
        }
    }
    return EXIT_SUCCESS;
}
