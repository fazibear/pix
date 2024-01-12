#pragma once
#include <matrix.h>

class Pix {
private:
  Matrix *matrix;

public:
  Pix();
  ~Pix();
  void step();
};
