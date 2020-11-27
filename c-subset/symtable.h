#include <string.h>

struct Node{
    char id[20];
    char type[10];
};

class SymTable{
    struct Node table[10000];
    int cnt;
public:
    SymTable() {
        cnt=0;
    }
    int find(char* str) {
        for(int i=0; i<cnt; i++) 
            if(!strcmp(table[i].id, str)) return i;
        return -1;
    }

    void push2table(char* id, char* type) {
        int &i=cnt;
        strcpy(table[i].id, id);
        strcpy(table[i].type, type);
        i++;
    }

} symtable;


