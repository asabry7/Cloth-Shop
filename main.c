#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/wait.h>
#include "ShopProcess.h"
#include "CustomerProcess.h"
#include "InventoryManagerProcess.h"

#define SHM_NAME "/cloth_shm"
#define SHM_PID_NAME "/updater_pid_shm"
#define MAX_CLOTH 100
#define BUFFER_SIZE 300


int main() {
    int shm_fd, shm_fd_pid;
    Cloth_t *shared_data;
    PidStorage_t *pid_storage;

    shm_fd = shm_open(SHM_NAME, O_CREAT | O_RDWR, 0666);
    if (shm_fd == -1) {
        perror("Error opening shared memory");
        exit(EXIT_FAILURE);
    }
    ftruncate(shm_fd, sizeof(Cloth_t) * MAX_CLOTH);
    shared_data = (Cloth_t*) mmap(0, sizeof(Cloth_t) * MAX_CLOTH, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);

    shm_fd_pid = shm_open(SHM_PID_NAME, O_CREAT | O_RDWR, 0666);
    ftruncate(shm_fd_pid, sizeof(PidStorage_t));
    pid_storage = (PidStorage_t*) mmap(0, sizeof(PidStorage_t), PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd_pid, 0);

    LoadDatabase(shared_data);

    pid_t pid1 = fork();
    if (pid1 == 0) {
        StartShopProcess(shared_data);
        exit(EXIT_SUCCESS);
    }

    pid_t pid2 = fork();
    if (pid2 == 0) {
        StartCustomerProcess(shared_data, pid_storage);
        exit(EXIT_SUCCESS);
    }

    pid_t pid3 = fork();
    if (pid3 == 0) {
        StartInventoryManagerProcess(shared_data, pid_storage);
        exit(EXIT_SUCCESS);
    }

    // Store PIDs
    pid_storage->pid1 = pid1;
    pid_storage->pid3 = pid3;

    wait(NULL);
    wait(NULL);
    wait(NULL);

    munmap(shared_data, sizeof(Cloth_t) * MAX_CLOTH);
    close(shm_fd);
    shm_unlink(SHM_NAME);

    munmap(pid_storage, sizeof(PidStorage_t));
    close(shm_fd_pid);
    shm_unlink(SHM_PID_NAME);

    return 0;
}
