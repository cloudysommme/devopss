#include <iostream>
#include "func.h"
#include "HTTP_Server.h"

int main(int argc, char* argv[]) {
    if (argc > 1 && std::string(argv[1]) == "server") {
        CreateHTTPserver();
    } else {
        HyperbolicTangent ht;
        double x = 0.5;
        int n = 5;

        std::cout << "th(" << x << ") = " << ht.FuncA(x, n) << std::endl;
    }
    return 0;
}
