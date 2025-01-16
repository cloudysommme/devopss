#include <iostream>
#include <cassert>
#include "func.h"

int main() {
    HyperbolicTangent ht;
    assert(ht.FuncA(0.0, 3) == 0.0);
    assert(ht.FuncA(0.5, 3) > 0.46 && ht.FuncA(0.5, 3) < 0.47);
    assert(ht.FuncA(-0.5, 3) > -0.47 && ht.FuncA(-0.5, 3) < -0.46);
    std::cout << "All tests passed!" << std::endl;
    return 0;
}

