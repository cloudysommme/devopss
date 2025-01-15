#include <gtest/gtest.h>
#include "func.h"

TEST(HyperbolicTangentTest, TestFuncA) {
    HyperbolicTangent ht;
    double result = ht.FuncA(1.0, 3);
    EXPECT_NEAR(result, 1.0, 0.01);
}
