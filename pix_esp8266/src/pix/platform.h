#pragma once

#include <array>
#include <bitset>
#include <cstdint>
#include <string>
#include <unordered_map>

typedef struct tm *Time;

class Platform {

public:
  // output
  virtual inline void clear(){};
  virtual inline void draw(){};
  virtual inline void set_dot(uint8_t, uint8_t, uint8_t){};

  // butons
  virtual inline int8_t read_buttons() { return 0; };

  // network
  virtual inline std::string fetch(std::string) { return ""; };

  // time
  virtual inline time_t get_time() { return 0; };
  virtual inline Time get_datetime() { return nullptr; };

  // debug
  virtual inline void debug(std::string, ...){};
};
