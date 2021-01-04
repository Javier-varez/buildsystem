
#include "static_exported.h"
#include "shared_exported.h"

int main() {
  bool ok = (static_function() == 123456) &&
            (shared_function() == 1234);
  return !ok;
}
