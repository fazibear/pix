#include "matrix.h"

Matrix::Matrix() {
  // GPIO
  pinMode(A1, OUTPUT);
  pinMode(A2, OUTPUT);
  pinMode(A3, OUTPUT);
  pinMode(OE, OUTPUT);
  pinMode(LE, OUTPUT);
  pinMode(SDI, OUTPUT);
  pinMode(CLK, OUTPUT);

  // Buttons
  pinMode(BTN1, INPUT_PULLUP);
  pinMode(BTN2, INPUT_PULLUP);
  pinMode(BTN3, INPUT_PULLUP);
  pinMode(BTN4, INPUT_PULLUP);

  Serial.begin(115200);

  // Wifi
  debug("Connecting to wifi..");
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    delay(2000);
    debug("Retrying wifi connection..");
  }
  debug("IP address:");
  debug(WiFi.localIP().toString().c_str());

  // NTP
  debug("Setting time...");

  udp = new WiFiUDP();
  TimeChangeRule dstRule = {"CEST", Last, Sun, Mar, 2, 120};
  TimeChangeRule stdRule = {"CET", Last, Sun, Oct, 2, 60};
  tz = new Timezone(dstRule, stdRule);
  time = new NTPClient(*udp, TIME_SERVER, 0, TIME_REFRESH);

  time->begin();
  time->update();
}

void Matrix::clear() {
  for (uint8 y = 0; y < LINES; y++) {
    for (uint8 x = 0; x < BITS_PER_LINE; x++) {
      matrix[y][x] = 0;
    }
  }
}
void Matrix::set_dot(uint8 x, uint8 y, uint8 c) {
  if (x > 15 or y > 15) {
    return;
  }
  if (y % 2) {
    x = x + 16;
  }
  y = (y / 2) - ((y / 2) % 1);

  matrix[y][x] = c & 2;
  matrix[y][x + 32] = c & 4;
  matrix[y][x + 64] = c & 1;
}

void Matrix::set_line(uint8 row) {
  digitalWrite(A1, !(row & 1));
  digitalWrite(A2, !(row & 2));
  digitalWrite(A3, !(row & 4));
}

void Matrix::draw() {
  for (uint8 line = 0; line < LINES; line++) {
    set_line(line);
    digitalWrite(OE, 1);
    for (uint8 bit = 0; bit < BITS_PER_LINE; bit++) {
      digitalWrite(SDI, matrix[line][bit]);
      digitalWrite(CLK, 1);
      digitalWrite(CLK, 0);
    }
    digitalWrite(LE, 1);
    digitalWrite(LE, 0);
    digitalWrite(OE, 0);

    delayMicroseconds(2000);
  }

  set_line(0);
  digitalWrite(OE, 1);
}

int8_t Matrix::read_buttons() {
  int8 state = 0;

  if (!digitalRead(BTN1)) {
    state |= 1;
  }
  if (!digitalRead(BTN2)) {
    state |= 2;
  }

  // if (!digitalRead(BTN3)) {
  //   state |= 4;
  // }
  // if (!digitalRead(BTN4)) {
  //   state |= 8;
  // }

  return state;
}

time_t Matrix::get_time() {
  time->update();
  return tz->toLocal(time->getEpochTime());
}

Time Matrix::get_datetime() {
  time->update();
  time_t now = get_time();
  return localtime(&now);
}

std::string Matrix::fetch(std::string url) {
  std::string response = "error";

  if (WiFi.status() != WL_CONNECTED) {
    return response;
  }

  WiFiClientSecure client;
  client.setInsecure();
  HTTPClient http;

  if (!http.begin(client, url.c_str())) {
    return response;
  }

  int http_code = http.GET();
  if (http_code != HTTP_CODE_OK) {
    return response;
  }

  response = http.getString().c_str();
  http.end();
  return response.c_str();
}

void Matrix::debug(std::string s, ...) { Serial.println(s.c_str()); }
