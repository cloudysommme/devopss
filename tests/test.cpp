#include <iostream>
#include <vector>
#include <chrono>
#include <algorithm>
#include "../func.h"

void testElapsedTime() {
    auto t1 = std::chrono::high_resolution_clock::now();
    std::vector<double> aValues;
    aValues.reserve(800000);

    HyperbolicTangent ht;

    for (int i = 0; i < 800000; ++i) {
        aValues.push_back(ht.FuncA(0.5, 10));
    }

    for (int i = 0; i < 400; ++i) {
        std::sort(aValues.begin(), aValues.end());
    }

    auto t2 = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::seconds>(t2 - t1).count();

    std::cout << "Elapsed time: " << duration << " seconds" << std::endl;

    if (duration < 5 || duration > 20) {
        std::cerr << "Test failed: duration out of expected range" << std::endl;
        exit(EXIT_FAILURE);
    }

    std::cout << "Test passed: duration is within the expected range" << std::endl;
}

int main() {
    testElapsedTime();
    return 0;
}

