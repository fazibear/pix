#pragma once

#include <array>
#include <cstdint>
#include <string>

typedef std::array<uint8_t, 3> Time;

class Platform {
public:
  virtual inline void init(){};

  // output
  virtual inline void clear(){};
  virtual inline void draw(){};
  virtual inline void set_dot(uint8_t, uint8_t, bool, bool, bool){};

  // network
  virtual inline std::string fetch(std::string) { return ""; };

  // time
  virtual inline std::array<uint8_t, 3> get_time() { return {0, 0, 0}; };
};
