#include <bits/stdc++.h>
using namespace std;

#define MIN 1
#define MAX 100

int main(){
    for(int i = MIN; i <= MAX; i++){
        cout << "(" << i << "," << "\\'{\"fname\":\"f" << i << "\"," << "\"lname\": \"l" << i << "\"" <<  "}\\'" << "),\n";
    }

    /*for(int i = MIN; i <= MAX; i++){
        cout << "(" << i << "," << "\\'{\"name\":\"app" << i%20 << "\"" << "}\\'," << i%10 + 1 << "),\n";
    }*/

    return 0;
}