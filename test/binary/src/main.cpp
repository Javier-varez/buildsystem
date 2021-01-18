#include "static_exported.h"
#include "shared_exported.h"

#include <iostream>

int main() {
  bool ok = (static_function() == 123456) &&
            (shared_function() == 1234);
  std::cout << "OK: " << ok << std::endl;
  return !ok;
}
