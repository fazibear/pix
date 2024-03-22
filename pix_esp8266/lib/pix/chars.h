#pragma once

#include "screen.h"
#include <bitset>
#include <unordered_map>

namespace Chars {

#define CHAR_WIDTH 3
#define CHAR_HEIGHT 7

typedef std::array<std::bitset<CHAR_WIDTH>, CHAR_HEIGHT> Char;
typedef std::unordered_map<char, Char> const CharMap;

void put_char(Platform *, char, int8_t, int8_t, int8_t);

} // namespace Chars
