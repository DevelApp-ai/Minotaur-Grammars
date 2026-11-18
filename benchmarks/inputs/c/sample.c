#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_ITEMS 1024

typedef struct {
    int id;
    char name[64];
    double value;
} Item;

static int compare_items(const void *a, const void *b) {
    const Item *ia = (const Item *)a;
    const Item *ib = (const Item *)b;
    if (ia->value < ib->value) return -1;
    if (ia->value > ib->value) return 1;
    return 0;
}

int main(int argc, char **argv) {
    Item items[MAX_ITEMS];
    int count = 0;
    if (argc > 1) {
        count = atoi(argv[1]);
        if (count > MAX_ITEMS) count = MAX_ITEMS;
    }
    for (int i = 0; i < count; i++) {
        items[i].id = i;
        snprintf(items[i].name, sizeof(items[i].name), "item-%d", i);
        items[i].value = (i * 37 % 101) / 100.0;
    }
    qsort(items, count, sizeof(Item), compare_items);
    double total = 0.0;
    for (int i = 0; i < count; i++) {
        total += items[i].value;
        printf("%d %s %.4f\n", items[i].id, items[i].name, items[i].value);
    }
    fprintf(stderr, "total=%.4f count=%d\n", total, count);
    return count > 0 ? 0 : 1;
}
