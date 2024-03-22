#include "pc.h"

void PC::init() {
  std::cout << CLS;
  curl = curl_easy_init();
}

void PC::clear() {
  for (uint8_t y = 0; y < 16; y++) {
    for (uint8_t x = 0; x < 16; x++) {
      pixel_data[y][x] = 0;
    }
  }
}

void PC::set_dot(uint8_t x, uint8_t y, uint8_t color) {
  if (x < 0 || y < 0 || x > 15 || y > 15) {
    throw "Invalid coordinates";
  }
  pixel_data[y][x] = color;
}

void PC::draw() {
  std::cout << CLS;
  for (uint8_t y = 0; y < 16; y++) {
    for (uint8_t x = 0; x < 16; x++) {
      draw_pixel(pixel_data[y][x]);
    }
    std::cout << std::endl;
  }
  std::this_thread::sleep_for(std::chrono::microseconds(15000));
}

void PC::draw_pixel(char color) {
  switch (color) {
  case 1:
    std::cout << FRED(pixel);
    break;
  case 2:
    std::cout << FGRN(pixel);
    break;
  case 3:
    std::cout << FYEL(pixel);
    break;
  case 4:
    std::cout << FBLU(pixel);
    break;
  case 5:
    std::cout << FMAG(pixel);
    break;
  case 6:
    std::cout << FCYN(pixel);
    break;
  case 7:
    std::cout << FWHT(pixel);
    break;
  default:
    std::cout << FBLK(pixel);
    break;
  }
}

size_t PC::curl_write_f(char *bufptr, size_t size, size_t nitems,
                        std::string *s) {
  size_t newLength = size * nitems;
  s->append((char *)bufptr, newLength);
  return newLength;
}

time_t PC::get_time() {
  time_t now = time(0);
  return now;
}

Time PC::get_datetime() {
  time_t now = get_time();
  return localtime(&now);
}

std::string PC::fetch(std::string url) {
  CURLcode result = CURLE_OK;
  std::string response = "";

  if (curl) {
    std::cerr << "Fetching " << url << std::endl;
    curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, curl_write_f);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
    curl_easy_perform(curl);
  }

  if (result != CURLE_OK) {
    std::cerr << "Error: " << curl_easy_strerror(result) << std::endl;
    return "error";
  }

  // Fetch the content of the url
  // ...

  std::cerr << "Response: " << response << std::endl;
  return response;
}

void PC::debug(std::string msg, ...) { std::cerr << msg << std::endl; }
