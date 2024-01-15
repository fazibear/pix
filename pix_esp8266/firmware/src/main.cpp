#include "esp.h"
#include "pix.h"

Pix *pix;

void setup() {
  Serial.begin(115200);
  Serial.println("Booting..");
  pix = new Pix(new Esp());
}

void loop() { pix->step(); }
