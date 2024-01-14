#pragma once

#include <string>

using namespace std;

class Network {
public:
  virtual inline void init(){};
  virtual inline string fetch(string) { return ""; };
};
