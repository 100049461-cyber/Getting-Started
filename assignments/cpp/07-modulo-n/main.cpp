#include <iostream>
#include <vector>
using namespace std;

int main() {
    int n;
    cin >> n;
    vector<int> v(n);
    for (int i = 0; i < n; i++) {
        cin >> v[i];
    }
    int repmod = v[0];
    for (int i = 1; i < n; i++) {  
        repmod = repmod % v[i];
    }
    cout << repmod << "\n";
    return 0;
}
