#pragma once

#include "chars.h"
#include "screen.h"
#include <bitset>

using namespace std;

class Weather : public Screen {
private:
  Platform *platform;
  std::string icon;
  std::string temp;
  bool day;
  bool frame;
  bitset<8> const sun_0[8]{
      bitset<8>("00100100"), //
      bitset<8>("00000000"), //
      bitset<8>("10011001"), //
      bitset<8>("00111100"), //
      bitset<8>("00111100"), //
      bitset<8>("10011001"), //
      bitset<8>("00000000"), //
      bitset<8>("00100100")  //
  };
  bitset<8> const sun_1[8]{
      bitset<8>("00000000"), //
      bitset<8>("00100100"), //
      bitset<8>("01011010"), //
      bitset<8>("00111100"), //
      bitset<8>("00111100"), //
      bitset<8>("01011010"), //
      bitset<8>("00100100"), //
      bitset<8>("00000000")  //
  };
  bitset<8> const moon_0[8]{
      bitset<8>("00011100"), //
      bitset<8>("00000110"), //
      bitset<8>("00100011"), //
      bitset<8>("01110011"), //
      bitset<8>("00100011"), //
      bitset<8>("00000011"), //
      bitset<8>("00000110"), //
      bitset<8>("00011100")  //
  };
  bitset<8> const moon_1[8]{
      bitset<8>("00011100"), //
      bitset<8>("00000110"), //
      bitset<8>("01010011"), //
      bitset<8>("00100011"), //
      bitset<8>("01010011"), //
      bitset<8>("00000011"), //
      bitset<8>("00000110"), //
      bitset<8>("00011100")  //
  };
  bitset<10> const cloud[7]{
      bitset<10>("0000011100"), //
      bitset<10>("0001111110"), //
      bitset<10>("0111111111"), //
      bitset<10>("1111111111"), //
      bitset<10>("1111111111"), //
      bitset<10>("1111111110"), //
      bitset<10>("0110011000"), //
  };

  bitset<8> const rain_0[6]{
      bitset<8>("10101000"), //
      bitset<8>("01010100"), //
      bitset<8>("00000000"), //
      bitset<8>("00101010"), //
      bitset<8>("00010101"), //
      bitset<8>("00000000")  //
  };

  bitset<8> const rain_1[6]{
      bitset<8>("00000000"), //
      bitset<8>("10101000"), //
      bitset<8>("01010100"), //
      bitset<8>("00000000"), //
      bitset<8>("00101010"), //
      bitset<8>("00010101")  //
  };

  bitset<8> const snow_0[4]{
      bitset<8>("10010010"), //
      bitset<8>("01001001"), //
      bitset<8>("10010010"), //
      bitset<8>("01001001")  //
  };

  bitset<8> const snow_1[4]{
      bitset<8>("01001001"), //
      bitset<8>("10010010"), //
      bitset<8>("01001001"), //
      bitset<8>("10010010")  //
  };

  bitset<7> const thunder[5]{
      bitset<7>("1000000"), //
      bitset<7>("0100000"), //
      bitset<7>("0010100"), //
      bitset<7>("0001010"), //
      bitset<7>("0000001"), //
  };

  bitset<16> const mist[8]{
      bitset<16>("0000011111110000"), //
      bitset<16>("0111111111111100"), //
      bitset<16>("0011111111111111"), //
      bitset<16>("0001111111111110"), //
      bitset<16>("0000111111111100"), //
      bitset<16>("0001111111100000"), //
      bitset<16>("0000111111111110"), //
      bitset<16>("0111111111111000"), //
  };

public:
  Weather(Platform *);
  ~Weather();
  void update();
  void refresh();
};
