#pragma once

#include "chars.h"
#include "screen.h"
#include <bitset>

class Weather : public Screen {
private:
  Platform *platform;
  std::string icon;
  std::string temp;
  bool day;
  bool frame;
  std::bitset<8> const sun_0[8]{
      std::bitset<8>("00100100"), //
      std::bitset<8>("00000000"), //
      std::bitset<8>("10011001"), //
      std::bitset<8>("00111100"), //
      std::bitset<8>("00111100"), //
      std::bitset<8>("10011001"), //
      std::bitset<8>("00000000"), //
      std::bitset<8>("00100100")  //
  };
  std::bitset<8> const sun_1[8]{
      std::bitset<8>("00000000"), //
      std::bitset<8>("00100100"), //
      std::bitset<8>("01011010"), //
      std::bitset<8>("00111100"), //
      std::bitset<8>("00111100"), //
      std::bitset<8>("01011010"), //
      std::bitset<8>("00100100"), //
      std::bitset<8>("00000000")  //
  };
  std::bitset<8> const moon_0[8]{
      std::bitset<8>("00011100"), //
      std::bitset<8>("00000110"), //
      std::bitset<8>("00100011"), //
      std::bitset<8>("01110011"), //
      std::bitset<8>("00100011"), //
      std::bitset<8>("00000011"), //
      std::bitset<8>("00000110"), //
      std::bitset<8>("00011100")  //
  };
  std::bitset<8> const moon_1[8]{
      std::bitset<8>("00011100"), //
      std::bitset<8>("00000110"), //
      std::bitset<8>("01010011"), //
      std::bitset<8>("00100011"), //
      std::bitset<8>("01010011"), //
      std::bitset<8>("00000011"), //
      std::bitset<8>("00000110"), //
      std::bitset<8>("00011100")  //
  };
  std::bitset<10> const cloud[7]{
      std::bitset<10>("0000011100"), //
      std::bitset<10>("0001111110"), //
      std::bitset<10>("0111111111"), //
      std::bitset<10>("1111111111"), //
      std::bitset<10>("1111111111"), //
      std::bitset<10>("1111111110"), //
      std::bitset<10>("0110011000"), //
  };

  std::bitset<8> const rain_0[6]{
      std::bitset<8>("10101000"), //
      std::bitset<8>("01010100"), //
      std::bitset<8>("00000000"), //
      std::bitset<8>("00101010"), //
      std::bitset<8>("00010101"), //
      std::bitset<8>("00000000")  //
  };

  std::bitset<8> const rain_1[6]{
      std::bitset<8>("00000000"), //
      std::bitset<8>("10101000"), //
      std::bitset<8>("01010100"), //
      std::bitset<8>("00000000"), //
      std::bitset<8>("00101010"), //
      std::bitset<8>("00010101")  //
  };

  std::bitset<8> const snow_0[4]{
      std::bitset<8>("10010010"), //
      std::bitset<8>("01001001"), //
      std::bitset<8>("10010010"), //
      std::bitset<8>("01001001")  //
  };

  std::bitset<8> const snow_1[4]{
      std::bitset<8>("01001001"), //
      std::bitset<8>("10010010"), //
      std::bitset<8>("01001001"), //
      std::bitset<8>("10010010")  //
  };

  std::bitset<7> const thunder[5]{
      std::bitset<7>("1000000"), //
      std::bitset<7>("0100000"), //
      std::bitset<7>("0010100"), //
      std::bitset<7>("0001010"), //
      std::bitset<7>("0000001"), //
  };

  std::bitset<16> const mist[8]{
      std::bitset<16>("0000011111110000"), //
      std::bitset<16>("0111111111111100"), //
      std::bitset<16>("0011111111111111"), //
      std::bitset<16>("0001111111111110"), //
      std::bitset<16>("0000111111111100"), //
      std::bitset<16>("0001111111100000"), //
      std::bitset<16>("0000111111111110"), //
      std::bitset<16>("0111111111111000"), //
  };

public:
  Weather(Platform *);
  ~Weather();
  void update();
  void refresh();
};
