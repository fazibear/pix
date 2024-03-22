#pragma once

#include "platform.h"

class Screen {

#define BLACK 0
#define RED 1
#define GREEN 2
#define YELLOW 3
#define BLUE 4
#define PURPLE 5
#define CYAN 6
#define WHITE 7

public:
  int screen_frames = 500;
  int throttle = 1;
  int refresh_every = 0;
  int refreshed_at = 0;

  Platform *platform;

  virtual inline void update(){};
  virtual inline void refresh(){};
};
