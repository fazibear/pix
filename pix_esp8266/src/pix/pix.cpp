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

  screens = {
      {"clock", new Clock(p)},     {"poo", new Poo(p)},
      {"lastfm", new LastFM(p)},   {"eth", new ETH(p)},
      {"btc", new BTC(p)},         {"year", new Year(p)},
      {"weather", new Weather(p)}, {"binclock", new BinClock(p)},
      {"crab", new Crab(p)},       {"ip", new Ip(p)},
  };

  screens_order = {
      "clock", "poo",      "clock", "lastfm", "clock", "eth",
      "clock", "btc",      "clock", "year",   "clock", "weather",
      "clock", "binclock", "clock", "crab",   "clock", "ip",
  };

  current_screen = 0;
}

void Pix::step() {
  check_buttons();
  frame++;

  Screen *current_screen = get_current_screen();

  if (frame > current_screen->screen_frames) {
    next_screen();
    refresh();
  }

  if (frame % current_screen->throttle == 0) {
    current_screen->update();
  }

  platform->draw();
}

Screen *Pix::get_current_screen() {
  return screens[screens_order[current_screen]];
}

void Pix::refresh() {
  Screen *current_screen = get_current_screen();

  if (current_screen->refresh_every != 0) {
    int now = platform->get_time();
    if (now - current_screen->refreshed_at > current_screen->refresh_every) {
      current_screen->refreshed_at = now;
      current_screen->refresh();
    }
  }
}

void Pix::next_screen() {
  current_screen++;
  frame = 0;
  if (current_screen >= screens_order.size()) {
    current_screen = 0;
  }
}

void Pix::prev_screen() {
  current_screen--;
  frame = 0;
  if (current_screen < 0) {
    current_screen = screens_order.size() - 1;
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
