#include "outputs/stdout.h"
#include "pix.h"

Pix *pix;

void setup() { pix = new Pix(new StdOut()); }
void loop() { pix->step(); }

int main() {
  pix = new Pix(new StdOut());
  while (true) {
    pix->step();
  }

  return 0;
}
