#include <iostream>
using namespace std;

int main() {
    int n;
    cin >> n;
    int v[n];
    for (int i = 0; i < n; i++) {
        cin >> v[i];
    }
    long long sum = 0;
    for (int i = 0; i < n; i++) {
        sum += v[i];
    }
    cout << sum << "\n";
    return 0;
}
