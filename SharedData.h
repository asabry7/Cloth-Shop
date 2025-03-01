#ifndef SHARED_DATA_H
#define SHARED_DATA_H
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>
#define MAX_CLOTH 100
#define BUFFER_SIZE 300

#define SEM_NAME "/my_semaphore"
#define SHM_NAME "/cloth_shm"
#define SHM_PID_NAME "/updater_pid_shm"

typedef struct {
    char name[50];
    float price;
    int stock;
} Cloth_t;

typedef struct {
    pid_t pid1;
    pid_t pid3;
} PidStorage_t;

int LoadDatabase(Cloth_t *shared_data);
void WriteDatabase(Cloth_t *shared_data);

#endif
