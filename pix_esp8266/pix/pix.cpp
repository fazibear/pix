#include "pix.h"
#include "screens/bin_clock.h"
#include "screens/clock.h"
#include "screens/crab.h"
#include "screens/random.h"
#include "screens/year.h"

Pix::Pix(Platform *p) {
  frame = 0;

  platform = p;
  platform->init();

  current_screen = 0;
  nscreens = 0;

  add_screen(new BinClock(p));
  add_screen(new Clock(p));
  add_screen(new Random(p));
  add_screen(new Year(p));
  add_screen(new Crab(p));
}

void Pix::step() {
  frame++;
  if (frame > screens[current_screen]->screen_frames) {
    next_screen();
    platform->clear();
    frame = 0;
  }

  screens[current_screen]->update();

  platform->draw();
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
