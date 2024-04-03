#pragma once

#include "ArduinoJson.h"
#include "chars.h"
#include "screen.h"
#include <cctype>

class LastFM : public Screen {
private:
  Platform *platform;
  std::string info;
  int position;
  int len;
  bool now;

public:
  LastFM(Platform *);
  ~LastFM();
  void update();
  void refresh();
};
