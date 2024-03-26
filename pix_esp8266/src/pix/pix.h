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
  int button_pressed;

  void add_screen(Screen *screen);
  void next_screen();
  void prev_screen();
  void check_buttons();

public:
  Pix(Platform *);
  ~Pix();
  void step();
};
