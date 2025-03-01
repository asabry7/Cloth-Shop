#include "ShopProcess.h"

sem_t *sem;

void handle_sigint(int sig) {
    printf("\nSIGINT received. Cleaning up...\n");

    if (sem) {
        sem_close(sem);
        printf("Semaphore closed successfully.\n");
    }

    exit(0);
}

void ShowAllClothes(Cloth_t *shopClothes) {
    printf("\n====================== Clothing Inventory =====================\n");
    int i = 0;

    sem_wait(sem);

    while (strcmp(shopClothes[i].name, "END_OF_DATA") != 0) {
        printf("Name: %s, Price: %.2f, Stock: %d\n", shopClothes[i].name, shopClothes[i].price, shopClothes[i].stock);
        i++;
    }
    printf("==============================================================\n");
    sem_post(sem);
    


}

void StartShopProcess(Cloth_t *shared_data) {

    struct sigaction sa;
    sa.sa_handler = handle_sigint;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0; // Default behavior

    if (sigaction(SIGINT, &sa, NULL) == -1) {
        perror("sigaction failed");
        exit(EXIT_FAILURE);
    }


    sem = sem_open(SEM_NAME, O_RDWR);

    while (1) {
        ShowAllClothes(shared_data);
        sleep(8);
    }

}
