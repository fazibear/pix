#pragma once

#include <array>
#include <cstdint>
#include <string>

typedef struct tm *Time;

class Platform {
public:
  virtual inline void init(){};

  // output
  virtual inline void clear(){};
  virtual inline void draw(){};
  virtual inline void set_dot(uint8_t, uint8_t, uint8_t){};

  // network
  virtual inline std::string fetch(std::string) { return ""; };

  // time
  virtual inline Time get_time() { return nullptr; };

  // debug
  virtual inline void debug(char *, ...){};
};
