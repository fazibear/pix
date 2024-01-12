#include "pix.h"
#include "screens/crab.h"

Pix::Pix(Output *output) {
  this->output = output;
  this->output->clean();

  add_screen(new Crab());
}

void Pix::step() {}

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
