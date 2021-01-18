
#include <gtest/gtest.h>
#include <gmock/gmock.h>

#include "static_exported.h"
#include "shared_exported.h"

TEST(test, test) {
  EXPECT_EQ(static_function(), 123456);
  EXPECT_EQ(shared_function(), 1234);
}
