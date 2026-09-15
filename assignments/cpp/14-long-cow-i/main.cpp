#include <iostream>
#include <string>
using namespace std;

int main() {
    string dih;
    getline(cin, dih);
    int d = dih.length();
    getline(cin, dih);
    int ih = dih.length();
    if (d > ih) {
        cout << "nohj\n";
    } else if (d < ih) {
        cout << "john\n";
    } else {
        cout << "-1\n";
    }
    return 0;
}
