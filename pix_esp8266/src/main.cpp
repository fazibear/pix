#include <Arduino.h>
#include <Pix.h>

Pix *pix;

void setup() { pix = new Pix(); }
void loop() { pix->step(); }
