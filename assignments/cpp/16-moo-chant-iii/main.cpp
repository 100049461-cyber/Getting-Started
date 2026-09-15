#include <iostream>
#include <string>
using namespace std;

int main() {
    string dih;
    while (cin >> dih) {
        cout << dih;
        if (!cin.eof()) {
            cout << '\n';
        }
    }

    return 0;
}
