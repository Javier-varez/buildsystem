#include "static_exported.h"
#include "shared_exported.h"
#include "custom_source.h"

#include <iostream>

int main() {
  bool ok = (static_function() == 123456) &&
            (shared_function() == 1234) &&
            (generated_value == 12345678);
  std::cout << "OK: " << ok << std::endl;
  return !ok;
}
