#include "pix.h"
#include "screens/crab.h"
#include "screens/random.h"
#include <iostream>

Pix::Pix(Output *out) {
  output = out;
  output->clear();

  current_screen = 0;
  nscreens = 0;

  add_screen(new Random());
}

void Pix::step() {
  PixelData *data = screens[current_screen]->update();

  for (int y = 0; y < 16; y++) {
    for (int x = 0; x < 16; x++) {
      output->set_dot(x, y, (*data[x][y])[0], (*data[x][y])[1],
                      (*data[x][y])[2]);
    }
  }
  output->draw();
}

void Pix::add_screen(Screen *screen) {
  if (nscreens < MAX_SCREENS) {
    screens[nscreens] = screen;
    nscreens++;
  }
}

void Pix::next_screen() {
  current_screen++;
  if (current_screen >= nscreens) {
    current_screen = 0;
  }
}
