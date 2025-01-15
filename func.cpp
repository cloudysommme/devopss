#include "func.h"

double HyperbolicTangent::FuncA(double x) {
    double result = 0;
    for (int i = 1; i <= 3; ++i) {
        double term = (std::pow(4, i) * (std::pow(4, i) - 1) * std::pow(x, 2 * i - 1)) / std::tgamma(2 * i + 1);
        result += term;
    }
    return result;
}

