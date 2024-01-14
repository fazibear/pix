#include "espwifi.h"
#include "matrix.h"
#include "pix.h"
#include <Arduino.h>

Pix *pix;

void setup() {
  Serial.begin(115200);
  Serial.println("Booting..");
  pix = new Pix(new Matrix(), new EspWifi());
}

void loop() { pix->step(); }
