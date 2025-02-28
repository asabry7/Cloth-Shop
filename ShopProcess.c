#include "ShopProcess.h"
#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <semaphore.h> // For semaphores


void ShowAllClothes(Cloth_t *shopClothes) {
    printf("\n====================== Clothing Inventory =====================\n");
    int i = 0;
    while (strcmp(shopClothes[i].name, "END_OF_DATA") != 0) {
        printf("Name: %s, Price: %.2f, Stock: %d\n", shopClothes[i].name, shopClothes[i].price, shopClothes[i].stock);
        i++;
    }
    printf("==============================================================\n");
}

void StartShopProcess(Cloth_t *shared_data) {
    while (1) {
        ShowAllClothes(shared_data);
        sleep(8);
    }
}
