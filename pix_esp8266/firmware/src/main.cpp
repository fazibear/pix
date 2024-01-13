#include "matrix.h"
#include "pix.h"
#include <Arduino.h>

Pix *pix;
Matrix *matrix;

void setup() {
  matrix = new Matrix();
  matrix->clear();
  // matrix->set_dot(0, 0, 1, 1, 1);
}

void loop() { matrix->draw(); }
