#pragma once
#include "platform.h"
#include "screen.h"

#define MAX_SCREENS 10

class Pix {
private:
  Platform *platform;

  Screen *screens[MAX_SCREENS];

  int current_screen;
  int nscreens;
  int frame;

  void add_screen(Screen *screen);
  void next_screen();

  PixelData *get_current_pixel_data();

public:
  Pix(Platform *);
  ~Pix();
  void step();
};
