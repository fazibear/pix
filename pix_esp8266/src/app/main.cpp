#include "pc.h"

Pix *pix;

int main() {
  pix = new Pix(new PC());
  while (true) {
    pix->step();
  }

  return 0;
}
