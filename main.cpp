#include <iostream>
#include "funcA.h"

int main() {
    HyperbolicTangent ht;
    double x = 0.5;
    std::cout << "th(" << x << ") = " << ht.FuncA(x) << std::endl;
    return 0;
}

