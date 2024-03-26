#include "esp.h"
#include "pix.h"

Pix *pix;

void setup() { pix = new Pix(new Esp()); }

void loop() { pix->step(); }
