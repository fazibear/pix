#pragma once

#include <string>

class Network {
public:
  virtual inline void init(){};
  virtual inline std::string fetch(std::string) { return ""; };
};
