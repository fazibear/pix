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

void put_char(Platform *, char, int8_t, int8_t, int8_t);

} // namespace Chars
