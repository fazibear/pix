#include "matrix.h"
#include "pix.h"
#include <Arduino.h>

Pix *pix;

void setup() { pix = new Pix(new Matrix()); }
void loop() { pix->step(); }
