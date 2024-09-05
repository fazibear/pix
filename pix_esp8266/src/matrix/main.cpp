#include "matrix.h"
#include "pix.h"

Pix *pix;

void setup() { pix = new Pix(new Matrix()); }

void loop() { pix->step(); }
