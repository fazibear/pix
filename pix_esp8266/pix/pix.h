#pragma once
#include "output.h"
#include "screen.h"

#define MAX_SCREENS 10

class Pix {
private:
  Output *output;
  int current_screen;
  int nscreens;
  void add_screen(Screen *screen);
  void next_screen();
  PixelData *get_current_pixel_data();
  Screen *screens[MAX_SCREENS];

public:
  Pix(Output *);
  ~Pix();
  void step();
};
