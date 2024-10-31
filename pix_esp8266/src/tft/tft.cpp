#include "tft.h"

TFT::TFT() {
  Serial.begin(115200);

  setup_wifi();
  setup_time();
  setup_tft();
  setup_ota();
}

void TFT::clear() {
  for (uint8_t y = 0; y < 16; y++) {
    for (uint8_t x = 0; x < 16; x++) {
      pixel_data[y][x] = 0;
    }
  }
}

void TFT::set_dot(uint8 x, uint8 y, uint8 c) {
  if (x < 0 || y < 0 || x > 15 || y > 15) {
    return;
  }
  pixel_data[y][x] = c;
}

uint32_t TFT::to_rgb(uint8_t color) {
  switch (color) {
  case 1:
    return TFT_RED;
  case 2:
    return TFT_GREEN;
  case 3:
    return TFT_YELLOW;
  case 4:
    return TFT_BLUE;
  case 5:
    return TFT_PURPLE;
  case 6:
    return TFT_CYAN;
  case 7:
    return TFT_WHITE;
  default:
    return TFT_BLACK;
  }
}

void TFT::draw() {
  auto start_time = millis();

  ArduinoOTA.handle();

  for (uint8_t y = 0; y < 16; y++) {
    for (uint8_t x = 0; x < 16; x++) {
      if (pixel_data[y][x] != pixel_data_old[y][x]) {
        tft->fillRect(x * 15, y * 15, 14, 14, to_rgb(pixel_data[y][x]));
        pixel_data_old[y][x] = pixel_data[y][x];
      }
    }
  }
  auto delay_ms = 20 - (millis() - start_time);
  if (delay_ms > 0) {
    delay(delay_ms);
  };
}

int8_t TFT::read_buttons() { return 0; }

time_t TFT::get_time() {
  time->update();
  return tz->toLocal(time->getEpochTime());
}

Time TFT::get_datetime() {
  time->update();
  time_t now = get_time();
  return localtime(&now);
}

std::string TFT::fetch(std::string url) {
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

void TFT::debug(std::string s, ...) { Serial.println(s.c_str()); }

void TFT::setup_wifi() {
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
}

void TFT::setup_time() {
  debug("Setting time...");

  TimeChangeRule dstRule = {"CEST", Last, Sun, Mar, 2, 120};
  TimeChangeRule stdRule = {"CET", Last, Sun, Oct, 2, 60};
  tz = new Timezone(dstRule, stdRule);
  udp = new WiFiUDP();
  time = new NTPClient(*udp, TIME_SERVER, 0, TIME_REFRESH);
  time->begin();
  time->update();
}

void TFT::setup_tft() {
  pinMode(TFT_BACKLIGHT, OUTPUT);
  digitalWrite(TFT_BACKLIGHT, LOW);

  tft = new TFT_eSPI();
  tft->init();
  tft->fillScreen(TFT_BLACK);
}

void TFT::setup_ota() {
  ArduinoOTA.setHostname("minipix");
  // ArduinoOTA.setPassword(WIFI_PASS);

  ArduinoOTA.onStart([]() {
    String type;
    if (ArduinoOTA.getCommand() == U_FLASH) {
      type = "sketch";
    } else { // U_FS
      type = "filesystem";
    }

    // NOTE: if updating FS this would be the place to unmount FS using FS.end()
    Serial.println("Start updating " + type);
  });
  ArduinoOTA.onEnd([]() {
    Serial.println("\nEnd");
    //    ESP.restart();
  });
  ArduinoOTA.onProgress([](unsigned int progress, unsigned int total) {
    Serial.printf("Progress: %u%%\r", (progress / (total / 100)));
  });
  ArduinoOTA.onError([](ota_error_t error) {
    Serial.printf("Error[%u]: ", error);
    if (error == OTA_AUTH_ERROR) {
      Serial.println("Auth Failed");
    } else if (error == OTA_BEGIN_ERROR) {
      Serial.println("Begin Failed");
    } else if (error == OTA_CONNECT_ERROR) {
      Serial.println("Connect Failed");
    } else if (error == OTA_RECEIVE_ERROR) {
      Serial.println("Receive Failed");
    } else if (error == OTA_END_ERROR) {
      Serial.println("End Failed");
    }
  });
  ArduinoOTA.begin();
}
