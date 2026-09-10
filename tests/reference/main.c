#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int op = @OP@;
    int many = op == 2 || op == 4 || op == 6 || op == 8 || op == 10;
    int n = op == 0 ? 1 : 2;
    if (many && scanf("%d", &n) != 1) return 1;
    long long *a = malloc((size_t)n * sizeof(*a));
    if (!a) return 1;
    for (int i = 0; i < n; i++) if (scanf("%lld", &a[i]) != 1) return 1;
    if (op == 1 || op == 2) {
        for (int i = n - 1; i >= 0; i--) printf("%lld%c", a[i], i ? ' ' : '\n');
    } else {
        long long answer = a[0];
        for (int i = 1; i < n; i++) {
            switch (op) {
                case 3: case 4: answer += a[i]; break;
                case 5: case 6: answer %= a[i]; break;
                case 7: case 8: answer = answer * a[i] % 1000000007; break;
                case 9: case 10: answer /= a[i]; break;
            }
        }
        printf("%lld\n", answer);
    }
    free(a);
    return 0;
}
