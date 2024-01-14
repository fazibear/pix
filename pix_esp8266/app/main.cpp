#include "curlnet.h"
#include "pix.h"
#include "stdout.h"

Pix *pix;

int main() {
  pix = new Pix(new StdOut(), new CurlNet());
  while (true) {
    pix->step();
  }

  return 0;
}
