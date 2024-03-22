#pragma once

#include "ArduinoJson.h"
#include "chars.h"
#include "screen.h"

class BTC : public Screen {
private:
  Platform *platform;
  std::string info;
  int position;
  int len;

public:
  BTC(Platform *);
  ~BTC();
  void update();
  void refresh();
};
