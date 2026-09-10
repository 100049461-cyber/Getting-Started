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
    long long answer = 1;
    for (int i = 0; i < n; i++) {
        answer = (answer * v[i]) % 1000000007LL;
    }
    cout << answer << "\n";
    return 0;
}
