#include <iostream>
#include <vector>
using namespace std;

int main() {
    // Write your solution here.
    int n;
    cin >> n;
    vector<int> v(n);
    for (int i = 0; i < n; i++) {
        cin >> v[i];
    }
    int repdiv = v[0];
    for (int i = 1; i < n; i++) {
        repdiv = repdiv / v[i];
    }
    cout << repdiv << "\n";
    return 0;
}
