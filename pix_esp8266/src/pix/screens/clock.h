#pragma once

#include "screen.h"
#include "time.h"

class Clock : public Screen {
private:
  Platform *platform;
  std::tuple<int, int> secords[60] = {
      std::make_tuple(8, 0),   std::make_tuple(9, 0),   std::make_tuple(10, 0),
      std::make_tuple(11, 0),  std::make_tuple(12, 0),  std::make_tuple(13, 0),
      std::make_tuple(14, 0),  std::make_tuple(15, 0),  std::make_tuple(15, 1),
      std::make_tuple(15, 2),  std::make_tuple(15, 3),  std::make_tuple(15, 4),
      std::make_tuple(15, 5),  std::make_tuple(15, 6),  std::make_tuple(15, 7),
      std::make_tuple(15, 8),  std::make_tuple(15, 9),  std::make_tuple(15, 10),
      std::make_tuple(15, 11), std::make_tuple(15, 12), std::make_tuple(15, 13),
      std::make_tuple(15, 14), std::make_tuple(15, 15), std::make_tuple(14, 15),
      std::make_tuple(13, 15), std::make_tuple(12, 15), std::make_tuple(11, 15),
      std::make_tuple(10, 15), std::make_tuple(9, 15),  std::make_tuple(8, 15),
      std::make_tuple(7, 15),  std::make_tuple(6, 15),  std::make_tuple(5, 15),
      std::make_tuple(4, 15),  std::make_tuple(3, 15),  std::make_tuple(2, 15),
      std::make_tuple(1, 15),  std::make_tuple(0, 15),  std::make_tuple(0, 14),
      std::make_tuple(0, 13),  std::make_tuple(0, 12),  std::make_tuple(0, 11),
      std::make_tuple(0, 10),  std::make_tuple(0, 9),   std::make_tuple(0, 8),
      std::make_tuple(0, 7),   std::make_tuple(0, 6),   std::make_tuple(0, 5),
      std::make_tuple(0, 4),   std::make_tuple(0, 3),   std::make_tuple(0, 2),
      std::make_tuple(0, 1),   std::make_tuple(0, 0),   std::make_tuple(1, 0),
      std::make_tuple(2, 0),   std::make_tuple(3, 0),   std::make_tuple(4, 0),
      std::make_tuple(5, 0),   std::make_tuple(6, 0),   std::make_tuple(7, 0)};

public:
  Clock(Platform *);
  ~Clock();
  void update();
};
