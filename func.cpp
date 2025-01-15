#include "func.h"
#include <cmath>

double HyperbolicTangent::FuncA(double x, int n) {
    double result = 0;
    for (int i = 1; i <= n; ++i) {
        double term = (std::pow(4, i) * (std::pow(4, i) - 1) * std::pow(x, 2 * i - 1)) / std::tgamma(2 * i + 1);
        result += term;
    }
    return result;
}

