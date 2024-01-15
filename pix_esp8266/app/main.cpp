#include "pc.h"
#include "pix.h"

Pix *pix;

int main() {
  pix = new Pix(new PC());
  while (true) {
    pix->step();
  }

  return 0;
}
