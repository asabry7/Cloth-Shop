#ifndef CUSTOMER_PROCESS_H
#define CUSTOMER_PROCESS_H
#define _GNU_SOURCE

#include "SharedData.h"

void StartCustomerProcess(Cloth_t *shared_data, PidStorage_t *pid_storage);

#endif
