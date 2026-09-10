#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "../grader/catalog.h"

int main(void) {
    int checked = 0;
    for (int id = 0; id < ASSIGNMENT_COUNT; id++) {
        int max_n = 0;
        for (int tc = 1; tc <= TEST_COUNT; tc++) {
            char path[256];
            snprintf(path, sizeof(path), "testcases/%s/%02d.in", assignments[id].name, tc);
            FILE *input = fopen(path, "r"); assert(input);
            snprintf(path, sizeof(path), "testcases/%s/%02d.out", assignments[id].name, tc);
            FILE *output = fopen(path, "r"); assert(output);
            int n = id == ECHO ? 1 : 2;
            if (assignments[id].n_values) assert(fscanf(input, "%d", &n) == 1);
            assert(n >= 1 && n <= 100000);
            if (n > max_n) max_n = n;
            long long *a = malloc((size_t)n * sizeof(*a)); assert(a);
            for (int i = 0; i < n; i++) {
                assert(fscanf(input, "%lld", &a[i]) == 1);
                assert(a[i] >= 0 && a[i] <= 1000000000);
                if (i && (id == DIVIDE_TWO || id == DIVIDE_N || id == MODULO_TWO || id == MODULO_N)) assert(a[i] > 0);
            }
            char extra;
            assert(fscanf(input, " %c", &extra) == EOF);
            if (id == REVERSE_TWO || id == REVERSE_N) {
                for (int i = 0; i < n; i++) {
                    long long got;
                    assert(fscanf(output, "%lld", &got) == 1 && got == a[n - i - 1]);
                }
            } else {
                long long expected = 0;
                if (id == PRODUCT_TWO || id == PRODUCT_N) {
                    expected = 1;
                    for (int i = 0; i < n; i++) expected = expected * a[i] % 1000000007;
                } else if (id == SUM_TWO || id == SUM_N) {
                    for (int i = 0; i < n; i++) expected += a[i];
                } else {
                    expected = a[0];
                    for (int i = 1; i < n; i++) {
                        if (id == MODULO_TWO || id == MODULO_N) expected %= a[i];
                        if (id == DIVIDE_TWO || id == DIVIDE_N) expected /= a[i];
                    }
                }
                long long got;
                assert(fscanf(output, "%lld", &got) == 1 && got == expected);
            }
            assert(fscanf(output, " %c", &extra) == EOF);
            free(a); fclose(input); fclose(output);
            checked++;
        }
        if (assignments[id].n_values) assert(max_n == 100000);
    }
    printf("Validated %d fixed cases, constraints, answers, and N = 100000 coverage.\n", checked);
}
