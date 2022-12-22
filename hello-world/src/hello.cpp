#include "hello-world/include/hello.h"
#include "hello-world/src/lib.rs"

#include <iostream>

void hello_from_cpp() {
  hello_from_rust();
  std::cout << "Hello from C++!" << std::endl;
}
