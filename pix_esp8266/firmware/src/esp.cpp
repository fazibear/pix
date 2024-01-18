#include "esp.h"

void Esp::init() {
  // Wifi
  Serial.println("Setting up wifi...");
  WiFi.mode(WIFI_AP_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    Serial.print(".");
    delay(2000);
  }
  Serial.println("done!");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  // NTP
  udp = new WiFiUDP();
  time = new NTPClient(*udp, time_server.c_str(), 3600);

  time->begin();
  time->update();

  // GPIO
  pinMode(A1, OUTPUT);
  pinMode(A2, OUTPUT);
  pinMode(A3, OUTPUT);
  pinMode(OE, OUTPUT);
  pinMode(LE, OUTPUT);
  pinMode(SDI, OUTPUT);
  pinMode(CLK, OUTPUT);
}

void Esp::clear() {
  for (uint8 y = 0; y < LINES; y++) {
    for (uint8 x = 0; x < BITS_PER_LINE; x++) {
      matrix[y][y] = 0;
    }
  }
}
void Esp::set_dot(uint8 x, uint8 y, bool r, bool g, bool b) {
  if (y % 2) {
    x = x + 16;
  }
  y = (y / 2) - ((y / 2) % 1);

  matrix[y][x] = g;
  matrix[y][x + 32] = b;
  matrix[y][x + 64] = r;
}

void Esp::set_line(uint8 row) {
  digitalWrite(A1, !(row & 1));
  digitalWrite(A2, !(row & 2));
  digitalWrite(A3, !(row & 4));
}

void Esp::draw() {
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

Time Esp::get_time() {
  time->update();

  time_t rawtime = time->getEpochTime();
  struct tm *now = localtime(&rawtime);

  return {now->tm_year + 1900, now->tm_mon + 1, now->tm_mday,
          now->tm_hour,        now->tm_min,     now->tm_sec};
}

std::string Esp::fetch(std::string url) {
  std::string response = "";
  if (WiFi.status() == WL_CONNECTED) {
    WiFiClient client;
    HTTPClient http;

    if (http.begin(client, url.c_str())) {
      int http_code = http.GET();
      Serial.println(http_code);
      if (http_code == HTTP_CODE_OK) {
        response = http.getString().c_str();
      }
    }
    http.end();
    Serial.print("Response: ");
    Serial.println(response.c_str());
  }
  return response;
}
