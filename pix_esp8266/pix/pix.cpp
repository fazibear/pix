#include "pix.h"
#include "screens/crab.h"

Pix::Pix(Output *output) {
  this->current_screen = 0;
  this->nscreens = 0;

  this->output = output;
  this->output->clear();

  add_screen(new Crab());
}

void Pix::step() {
  screens[current_screen]->update();
  output->set_dot(0, 0, 1, 1, 1);
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
