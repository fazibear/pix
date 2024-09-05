#include "pix.h"
#include "tft.h"

Pix *pix;

void setup() { pix = new Pix(new TFT()); }

void loop() { pix->step(); }
