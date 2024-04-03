#include "lastfm.h"
#include <cstdlib>
#include <cstring>

LastFM::LastFM(Platform *p) {
  platform = p;
  throttle = 4;
  refresh_every = 60 * 60;
  position = 16;
};

void LastFM::refresh() {
  std::string json =
      platform->fetch("https://ws.audioscrobbler.com/2.0/"
                      "?method=user.getrecenttracks"
                      "&limit=1&format=json"
                      "&user=" LASTFM_USER "&api_key=" LASTFM_KEY);
  // {"recenttracks":{"track":[{"artist":{"mbid":"","#text":"The Ultimate
  // System"},"streamable":"0","image":[{"size":"small","#text":""},{"size":"medium","#text":""},{"size":"large","#text":""},{"size":"extralarge","#text":""}],"mbid":"","album":{"mbid":"","#text":""},"name":"Overview","url":"https:\/\/www.last.fm\/music\/The+Ultimate+System\/_\/Overview","date":{"uts":"1712135044","#text":"03
  // Apr 2024,
  // 09:04"}}],"@attr":{"user":"FaziBear","totalPages":"99604","page":"1","perPage":"1","total":"99604"}}}
  JsonDocument doc;
  deserializeJson(doc, json);
  JsonVariant track = doc["recenttracks"]["track"][0];

  std::string name = track["name"].as<std::string>();
  std::string artist = track["artist"]["#text"].as<std::string>();
  now = track["@attr"]["nowplaying"];

  info = " " + artist + " - " + name;

  len = info.length() * 4;

  screen_frames = len * throttle + 64;
};

void LastFM::update() {
  if (position < -len) {
    position = 16;
  }

  position--;

  platform->clear();

  if (now) {
    Chars::put_char(platform, 'N', 1, 0, YELLOW);
    Chars::put_char(platform, 'O', 6, 0, YELLOW);
    Chars::put_char(platform, 'W', 11, 0, YELLOW);
  } else {
    Chars::put_char(platform, 'L', 1, 0, GREEN);
    Chars::put_char(platform, 'A', 4, 0, GREEN);
    Chars::put_char(platform, 'S', 8, 0, GREEN);
    Chars::put_char(platform, 'T', 12, 0, GREEN);
  }

  for (int j = 0; j < 5; j++) {
    size_t i = j + (position / -4);
    if (i >= 0 && i < info.length()) {
      Chars::put_char(platform, info[i], (i * 4) + position, 8, BLUE);
    }
  }
};
