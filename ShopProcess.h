#ifndef SHOP_PROCESS_H
#define SHOP_PROCESS_H
#define _GNU_SOURCE

#include "SharedData.h"
#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <semaphore.h> // For semaphores


void StartShopProcess(Cloth_t *shared_data);
void ShowAllClothes(Cloth_t *shopClothes);

#endif
