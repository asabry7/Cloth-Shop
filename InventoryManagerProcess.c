#include "InventoryManagerProcess.h"
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>
#include <semaphore.h> // For semaphores


#define SHM_NAME "/cloth_shm"
#define MAX_CLOTH 100

void handle_restock_signal(int sig, siginfo_t *info, void *context) {
    if (sig == SIGRTMIN) {

        sem_t *sem = sem_open(SEM_NAME, O_RDWR);

        Cloth_t * shared_data = (Cloth_t *) info->si_ptr;
        if (shared_data == MAP_FAILED) {
            perror("Error mapping shared memory");
            exit(EXIT_FAILURE);
        }

        // Prompt the user for restocking details
        char name[50];
        int quantity;
        float price;
        int itemExists = 0;

        printf("Enter the name of the new item: ");
        scanf("%s", name);
        printf("Enter the quantity: ");
        scanf("%d", &quantity);
        printf("Enter the price: ");
        scanf("%f", &price);

        // Find the item or an empty slot
        int i = 0;

        sem_wait(sem);
        while (strcmp(shared_data[i].name, "END_OF_DATA") != 0 && i < MAX_CLOTH - 1) {
            if (strcmp(shared_data[i].name, name) == 0) {
                itemExists = 1;
                break;
            }
            i++;
        }

        // Add or update the item
        if (!itemExists) {
            strcpy(shared_data[i].name, name);
            strcpy(shared_data[i + 1].name, "END_OF_DATA");
        }

        shared_data[i].price = price;
        shared_data[i].stock = quantity;

        sem_post(sem);
        printf("Restocking completed.\n");

        // Send confirmation signal back to the sender process
        sigqueue(info->si_pid, SIGRTMAX, (union sigval){0});
        sem_close(sem);
    }
}

void StartInventoryManagerProcess(Cloth_t *shared_data, PidStorage_t *pid_storage) {
    struct sigaction sa;
    sa.sa_sigaction = handle_restock_signal;
    sa.sa_flags = SA_SIGINFO;
    sigemptyset(&sa.sa_mask);
    sigaction(SIGRTMIN, &sa, NULL);

    pid_storage->pid3 = getpid();


    while (1) {
        
        pause();  // Wait for signals
    }
}
