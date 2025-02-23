#include "SharedData.h"

int LoadDatabase(Cloth_t *ShopCLothesItems) {
    char buf[BUFFER_SIZE];
    ssize_t bytesRead;
    int index = 0;
    int database_fd = open("database.txt", O_RDONLY);
    if (database_fd == -1) {
        perror("Error opening the database file");
        exit(EXIT_FAILURE);
    }
    while ((bytesRead = read(database_fd, buf, BUFFER_SIZE - 1)) > 0) {
        buf[bytesRead] = '\0';
        char *line = strtok(buf, "\n");
        while (line != NULL && index < MAX_CLOTH) {
            sscanf(line, "%49[^,],%f,%d", ShopCLothesItems[index].name, &ShopCLothesItems[index].price, &ShopCLothesItems[index].stock);
            index++;
            line = strtok(NULL, "\n");
        }
    } 
    
    if(bytesRead == -1) 
    {
        perror("Error reading the database file");
    }
    close(database_fd);
    strcpy(ShopCLothesItems[index].name, "END_OF_DATA");
    return index;
}

