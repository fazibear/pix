#include "pc.h"

using namespace std;

void PC::init() {
  cout << CLS;
  curl = curl_easy_init();
}

void PC::clear() {
  for (uint8_t y = 0; y < 16; y++) {
    for (uint8_t x = 0; x < 16; x++) {
      pixel_data[y][x] = 0;
    }
  }
}

void PC::set_dot(uint8_t x, uint8_t y, bool r, bool g, bool b) {
  pixel_data[y][x] = b << 2 | g << 1 | r;
}

void PC::draw() {
  cout << CLS;
  for (uint8_t y = 0; y < 16; y++) {
    for (uint8_t x = 0; x < 16; x++) {
      draw_pixel(pixel_data[y][x]);
    }
    cout << endl;
  }
  std::this_thread::sleep_for(std::chrono::microseconds(15000));
}

void PC::draw_pixel(char color) {
  switch (color) {
  case 1:
    cout << FRED(pixel);
    break;
  case 2:
    cout << FGRN(pixel);
    break;
  case 3:
    cout << FYEL(pixel);
    break;
  case 4:
    cout << FBLU(pixel);
    break;
  case 5:
    cout << FMAG(pixel);
    break;
  case 6:
    cout << FCYN(pixel);
    break;
  case 7:
    cout << FWHT(pixel);
    break;
  default:
    cout << FBLK(pixel);
    break;
  }
}

size_t PC::curl_write_f(char *bufptr, size_t size, size_t nitems, string *s) {
  size_t newLength = size * nitems;
  s->append((char *)bufptr, newLength);
  return newLength;
}

Time PC::get_time() {
  time_t t = time(0);
  std::tm *now = std::localtime(&t);
  return {(uint8_t)now->tm_hour, (uint8_t)now->tm_min, (uint8_t)now->tm_sec};
}

string PC::fetch(string url) {
  CURLcode result = CURLE_OK;
  string response;

  if (curl) {
    cerr << "Fetching " << url << endl;
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, curl_write_f);
    curl_easy_setopt(curl, CURLOPT_URL, &url);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
    curl_easy_perform(curl);
  }

  if (result != CURLE_OK) {
    cerr << "Error: " << curl_easy_strerror(result) << endl;
    return "error";
  }

  // Fetch the content of the url
  // ...
  return response;
}
