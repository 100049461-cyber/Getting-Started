#include <algorithm>
#include <iostream>
#include <vector>
using namespace std;

int main() {
    constexpr int op = @OP@;
    int n = op == 0 ? 1 : 2;
    if (op == 2 || op == 4 || op == 6 || op == 8 || op == 10) cin >> n;
    vector<long long> a(n);
    for (auto &value : a) cin >> value;
    if (op == 1 || op == 2) {
        reverse(a.begin(), a.end());
        for (auto value : a) cout << value << ' ';
        cout << '\n';
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
        cout << answer << '\n';
    }
}
