#pragma once

#include "screen.h"
#include <bitset>
#include <unordered_map>

namespace Chars {
using namespace std;

#define CHAR_WIDTH 3
#define CHAR_HEIGHT 7

typedef array<bitset<CHAR_WIDTH>, CHAR_HEIGHT> Char;
typedef unordered_map<char, Char> const CharMap;

void put_char(PixelData *data, char c, int x, int y, uint8_t color);

} // namespace Chars
