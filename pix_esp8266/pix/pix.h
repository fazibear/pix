#pragma once
#include "network.h"
#include "output.h"
#include "screen.h"

#define MAX_SCREENS 10

class Pix {
private:
  Output *output;
  Network *network;

  Screen *screens[MAX_SCREENS];

  int current_screen;
  int nscreens;
  int frame;

  void add_screen(Screen *screen);
  void next_screen();

  PixelData *get_current_pixel_data();

public:
  Pix(Output *, Network *);
  ~Pix();
  void step();
};
