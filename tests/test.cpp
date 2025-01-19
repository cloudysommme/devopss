#include <iostream>
#include <cmath>
#include <cassert>
#include "../func.h"

void testCompute() {
    HyperbolicTangent func;
    double x = 0.5;
    int n = 5;
    double result1 = func.FuncA(x, n);
    double expected1 = 4.43821;

    std::cout << "Computed result: " << result1 << std::endl;
    std::cout << "Expected result: " << expected1 << std::endl;

    assert(fabs(result1 - expected1) < 1e-3 && "Test failed for x = 0.5, n = 3");
}
int main() {
    testCompute();
    return 0;
}
