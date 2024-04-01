#include <unistd.h>

int main() {
  char* str = "Hello World!\n";
  size_t len = 13;
  write(STDOUT_FILENO, str, len);
}
