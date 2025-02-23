#ifndef INVENTORY_MANAGER_PROCESS_H
#define INVENTORY_MANAGER_PROCESS_H
#define _GNU_SOURCE

#include "SharedData.h"

void StartInventoryManagerProcess(Cloth_t *shared_data, PidStorage_t *pid_storage);

#endif
