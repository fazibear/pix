#pragma once

#include <cstdint>
#include <string>

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
  virtual inline std::string get_time() { return ""; };
};
