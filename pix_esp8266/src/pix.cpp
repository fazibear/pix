#include "pix.h"

Pix::Pix() {
  matrix = new Matrix();
  matrix->clean();
  matrix->set_dot(0, 0, 1, 1, 1);
}

void Pix::step() { matrix->draw(); }
