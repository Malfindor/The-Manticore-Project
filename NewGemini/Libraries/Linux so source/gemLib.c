// Linux library (.so) source
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char*** getUserInfo()
{
	FILE *file = fopen("/etc/passwd", "r");
    if (!file) {
        perror("fopen");
        return NULL;
    }
	
	char line[1024];
    size_t capacity = 16;
    size_t count = 0;
    char ***users = malloc(capacity * sizeof(char**));
    if (!users) {
        perror("malloc");
        fclose(file);
        return NULL;
    }
	
	while (fgets(line, sizeof(line), file)) {
        // Strip trailing newline
        line[strcspn(line, "\n")] = '\0';

        // Expand outer array if needed
        if (count >= capacity) {
            capacity *= 2;
            char ***tmp = realloc(users, capacity * sizeof(char**));
            if (!tmp) {
                perror("realloc");
                break;
            }
            users = tmp;
        }

        // Allocate space for one user's fields
        char **fields = malloc(7 * sizeof(char*));
        if (!fields) {
            perror("malloc");
            break;
        }

        // Tokenize into exactly 7 fields
        char *saveptr = NULL;
        char *tok = strtok_r(line, ":", &saveptr);
        size_t f = 0;
        for (; f < 7 && tok; ++f) {
            fields[f] = strdup(tok);
            tok = strtok_r(NULL, ":", &saveptr);
        }
        // If fewer than 7 fields, pad with empty strings
        for (; f < 7; ++f) {
            fields[f] = strdup("");
        }

        users[count++] = fields;
    }

    fclose(file);
    return users;
}
void freeArray(char*** input) //Allows for freeing memory using C, even though the main code is python
{
	free(input);
}