#include <stdio.h>

#define SIZE 2048

int count_increases(int ns[], int len) {
    int num = 0;

    for (int i = 0; i < len - 1; i++) {
        if (ns[i + 1] > ns[i])
            num = num + 1;
    }

    return num;
}

int count_windows(int ns[], int len) {
    int num = 0;

    for (int i = 0; i < len; i++) {
        int n1 = ns[i] + ns[i+1] + ns[i+2];
        int n2 = ns[i+1] + ns[i+2] + ns[i+3];
        if (n2 > n1)
            num = num + 1;
    }

    return num;
}

int main(void) {
    int ns[SIZE];
    int len = 0;
    int n;

    while (scanf("%d\n", &n) != EOF) {
        ns[len++] = n;
    }

    printf("%d\n", count_increases(ns, len));
    printf("%d\n", count_windows(ns, len));

    return 0;
}
