#include <stdio.h>
#include <stdlib.h>

#define CHECK(x)                                                               \
  if ((x) < 0) {                                                               \
    fprintf(stderr,                                                            \
            "Checked function returned negative value.\r\nCALLED FROM: "       \
            "%s\r\nFILE: %s\r\nLINE: %d\r\n",                                  \
            __PRETTY_FUNCTION__, __FILE__, __LINE__);                          \
    exit(-1);                                                                  \
  }

int main(void) {
  CHECK(printf("Hello, World!\n"));
  return EXIT_SUCCESS;
}
