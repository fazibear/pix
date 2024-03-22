#pragma once

#include "ArduinoJson.h"
#include "chars.h"
#include "screen.h"

class ETH : public Screen {
private:
  Platform *platform;
  std::string info;
  int position;
  int len;

public:
  ETH(Platform *);
  ~ETH();
  void update();
  void refresh();
};
