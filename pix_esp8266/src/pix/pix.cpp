#include "pix.h"
#include "screens/bin_clock.h"
#include "screens/btc.h"
#include "screens/clock.h"
#include "screens/crab.h"
#include "screens/eth.h"
#include "screens/ip.h"
#include "screens/lastfm.h"
#include "screens/poo.h"
#include "screens/weather.h"
#include "screens/year.h"

Pix::Pix(Platform *p) {
  frame = 0;

  platform = p;

  current_screen = 0;
  nscreens = 0;

  add_screen(new Clock(p));
  add_screen(new Poo(p));
  add_screen(new LastFM(p));
  add_screen(new ETH(p));
  add_screen(new BTC(p));
  add_screen(new Year(p));
  add_screen(new Weather(p));
  add_screen(new BinClock(p));
  add_screen(new Crab(p));
  add_screen(new Ip(p));
}

void Pix::step() {
  check_buttons();
  frame++;
  if (frame > screens[current_screen]->screen_frames) {
    next_screen();
  }

  if (screens[current_screen]->refresh_every != 0) {
    int now = platform->get_time();
    if (now - screens[current_screen]->refreshed_at >
        screens[current_screen]->refresh_every) {
      screens[current_screen]->refreshed_at = now;
      screens[current_screen]->refresh();
    }
  }

  if (frame % screens[current_screen]->throttle == 0) {
    screens[current_screen]->update();
  }

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
  frame = 0;
  if (current_screen >= nscreens) {
    current_screen = 0;
  }
}

void Pix::prev_screen() {
  current_screen--;
  frame = 0;
  if (current_screen < 0) {
    current_screen = nscreens - 1;
  }
}

void Pix::check_buttons() {
  int8_t buttons = platform->read_buttons();

  if (buttons == 0 && button_pressed > 0) {
    if (button_pressed == 1) {
      next_screen();
    }
    if (button_pressed == 2) {
      prev_screen();
    }
    // if (buttons & 4) {}
    // if (buttons & 8) {}
    button_pressed = 0;
  }

  if (buttons > 0) {
    button_pressed = buttons;
  }
}
