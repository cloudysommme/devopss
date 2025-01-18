#include <iostream>
#include "func.h"

int main() {
    HyperbolicTangent ht;
    double x = 0.5; 
    int n = 5;  

    std::cout << "th(" << x << ") = " << ht.FuncA(x, n) << std::endl;

    return 0;
}

