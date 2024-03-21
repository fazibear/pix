#pragma once

#include "ArduinoJson.h"
#include "chars.h"
#include "screen.h"

class Crypto : public Screen {
private:
  Platform *platform;
  std::string ip;
  int position;
  int len;

public:
  Crypto(Platform *);
  ~Crypto();
  void update();
  void refresh();
};
