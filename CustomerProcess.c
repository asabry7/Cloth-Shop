#define _GNU_SOURCE
#include "CustomerProcess.h"
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>
#include <semaphore.h> // For semaphores


#define BUFFER_SIZE 300


void WriteDatabase(Cloth_t *shared_data) {
    int database_fd = open("database.txt", O_WRONLY | O_CREAT | O_TRUNC, 0666);
    if (database_fd == -1) {
        perror("Error opening the database file");
        return;
    }

    int i = 0;
    while (strcmp(shared_data[i].name, "END_OF_DATA") != 0) {
        char buffer[BUFFER_SIZE];
        snprintf(buffer, BUFFER_SIZE, "%s,%.2f,%d\n", shared_data[i].name, shared_data[i].price, shared_data[i].stock);
        write(database_fd, buffer, strlen(buffer));
        i++;
    }

    close(database_fd);
    printf("Database written to file.\n");
}


void handle_confirmation(int sig) {
    // Empty handler for sigsuspend()
}

void StartCustomerProcess(Cloth_t *shared_data, PidStorage_t *pid_storage) {
    int choice;
    struct sigaction sa;
    sa.sa_handler = handle_confirmation;
    sigemptyset(&sa.sa_mask);
    sigaction(SIGRTMAX, &sa, NULL);
    union sigval val;

    while (1) {
        printf("\n1. Restock items\n2. Search for a piece\n3. Place an order\n4. Save and Exit\nEnter choice: ");
        scanf("%d", &choice);

        switch (choice) {
            case 1: {
                val.sival_ptr = shared_data;
                sigqueue(pid_storage->pid3, SIGRTMIN, val);

                sigset_t mask, oldmask;
                sigemptyset(&mask);
                sigaddset(&mask, SIGRTMAX);
                sigprocmask(SIG_BLOCK, &mask, &oldmask);

                sigsuspend(&oldmask);

                sigprocmask(SIG_SETMASK, &oldmask, NULL);

                printf("Restocking confirmed.\n");
                break;
            }

            case 2: 
            {
                char searchName[50];
                printf("Enter name of the cloth: ");
                scanf("%s", searchName);
                
                int found = 0;
                for (int i = 0; i < MAX_CLOTH; i++) {
                    if (strcmp(shared_data[i].name, searchName) == 0) {
                        printf("Found: Name: %s, Price: %.2f, Stock: %d\n", shared_data[i].name, shared_data[i].price, shared_data[i].stock);
                        found = 1;
                        break;
                    }
                }
                if (!found) {
                    printf("The product you typed is not available right now\n");
                }

                break;
            } 

            case 3:
            {
                char searchName[50];
                int quantity;
                printf("Enter name of the cloth to order: ");
                scanf("%s", searchName);
    
                int found = 0;
                for (int i = 0; i < MAX_CLOTH; i++) {
                    if (strcmp(shared_data[i].name, searchName) == 0) {
                        printf("Enter the quantity: ");
                        scanf("%d", &quantity);
                        found = 1;
                        if (shared_data[i].stock >= quantity) {
                            shared_data[i].stock -= quantity;
                            printf("Order placed for %s. Remaining stock: %d\n", shared_data[i].name, shared_data[i].stock);
                        } else {
                            printf("Sorry, %s is out of stock.\n", shared_data[i].name);
                        }
                        break;
                    }
                }
                if (!found) {
                    printf("The product you typed is not available right now\n");
                }

                break;
            }



            case 4:
                WriteDatabase(shared_data);
                sigqueue(pid_storage->pid1, SIGINT, (union sigval){0});
                sigqueue(pid_storage->pid3, SIGINT, (union sigval){0});
                return;
        }
    }
}
