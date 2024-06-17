#pragma once
#include "platform.h"
#include "screen.h"
#include <unordered_map>
#include <vector>

class Pix {
private:
  Platform *platform;

  std::unordered_map<std::string, Screen *> screens;
  std::vector<std::string> screens_order;

  int current_screen;
  int frame;
  int button_pressed;

  Screen *get_current_screen();
  void next_screen();
  void prev_screen();
  void check_buttons();
  void refresh();

public:
  Pix(Platform *);
  ~Pix();
  void step();
};
