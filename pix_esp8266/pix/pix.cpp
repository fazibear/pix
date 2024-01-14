#include "pix.h"
#include "screens/crab.h"
#include "screens/random.h"
#include <iostream>

Pix::Pix(Output *out, Network *net) {
  output = out;
  output->clear();

  network = net;
  network->init();

  current_screen = 0;
  nscreens = 0;

  add_screen(new Random());
  add_screen(new Crab());

  string ip = network->fetch("https://ipinfo.io/ip");
  cerr << "IP: " << ip << endl;
}

void Pix::step() {
  frame++;
  if (frame > 500) {
    next_screen();
    frame = 0;
  }

  PixelData *data = screens[current_screen]->update();

  for (int x = 0; x < 16; x++) {
    for (int y = 0; y < 16; y++) {
      output->set_dot(x, y, (*data[y][x])[0], (*data[y][x])[1],
                      (*data[y][x])[2]);
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
