#include <iostream>
#include <string>
using namespace std;

int main() {
    string dih;
    string dihl;
    int mx = 0;
    int n;
    cin >> n;
    cin.ignore();
    for (int i = 0; i < n; i++) {
        getline(cin, dih);
        if (dih.length() > mx) {
            mx = dih.length();
            dihl = dih;
        }
    }
    cout << mx << "\n" << dihl << "\n";
    return 0;
}
