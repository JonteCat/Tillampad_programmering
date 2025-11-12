/*
* Name: övningsprojekt
* Author: Jonathan Wiklund
* Date: 2025-11-12
* Description: This project uses a ds3231 to measure time and displays the time to an 1306 oled display, 
* Further, it measures temprature with ds3231 and displays a mapped value to a 9g-servo-motor.
*/

// Include Libraries
#include <RTClib.h>
#include <Wire.h>
#include <U8glib.h>
#include <Servo.h>
#include <LedControl.h>


// Init constants
int x0 = (128 / 2) + 20;
int y0 = 64 / 2;
float pi = 3.14159265359;
int r = 30;
// Init global variables

// Construct objects
Servo myservo;
RTC_DS3231 rtc;
U8GLIB_SSD1306_128X64 u8g(U8G_I2C_OPT_NO_ACK);
LedControl lc = LedControl(11, 12, 10, 1);


void setup() {
  // init communication
  Serial.begin(9600);
  Wire.begin();

  // Init Hardware
  rtc.begin();
  myservo.attach(3);
  /*
   The MAX72XX is in power-saving mode on startup,
   we have to do a wakeup call
   */
  lc.shutdown(0, false);
  /* Set the brightness to a medium values */
  lc.setIntensity(0, 8);
  /* and clear the display */
  lc.clearDisplay(0);

  // Settings
  rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));

  // Screen font
  u8g.setFont(u8g_font_4x6);
}



void loop() {
  oledWrite(getTime());
  servoWrite(getTemp());
  eightDigClock();
  //Serial.println(getTime());
  //Serial.println(temp);

  delay(200);
}

/*
* This function reads time from an ds3231 module and package the time as a String
*Parameters: Void
*Returns: time in hh mm ss as String and single digits as 0h 0m 0s
*/
String getTime() {
  DateTime now = rtc.now();

  return String(now.hour() < 10 ? "0" : "") + String(now.hour()) +
  " " + 
  String(now.minute() < 10 ? "0" : "") + String(now.minute()) +
  " " + 
  String(now.second() < 10 ? "0" : "") + String(now.second());
}

/*
* This function takes temprature from ds3231 and returns as a float
*Parameters: Void
*Returns: temprature as float 
*/
float getTemp() {
  return rtc.getTemperature();
}


/*
* This function takes a string and draws it to an oled display
*Parameters: - text: String to write to display
*Returns: void
*/
void oledWrite(String time) {
  // picture loop
  u8g.firstPage();
  do {
    u8g.drawStr(10, 10, time.c_str());
    //u8g.drawCircle(u8g_uint_t x0, u8g_uint_t y0, u8g_uint_t rad);
    analogClock();
    u8g.drawStr(10, 20, ("Temp" + String(getTemp()) + char(176) + "C").c_str());

  } while (u8g.nextPage());
}

/*
**This function draws an analog clock on the oled screen
*Parameters: Void
*Returns: void
*/
void analogClock() {
  DateTime now = rtc.now();

  int angleSecond = (360/60)*now.second();
  int angleMinute = (360/60)*now.minute();
  int angleHour = (360/12)*now.hour();
  u8g.drawCircle(x0, y0, r);
  u8g.drawLine(x0, y0, x0 + r * cos(degToRad(angleSecond - 90)), y0 + r * sin(degToRad(angleSecond - 90)));
  u8g.drawLine(x0, y0, x0 + r * cos(degToRad(angleMinute - 90)), y0 + r * sin(degToRad(angleMinute - 90)));
  u8g.drawLine(x0, y0, x0 + (r - r/2) * cos(degToRad(angleHour - 90)), y0 + r * sin(degToRad(angleHour - 90)));
}

/*
**This function turns degrees to radians
*Parameters: float Degrees
*Returns: float
*/
float degToRad(float degrees) {
  return (degrees*pi)/180;
}

/*
* takes a temprature value and maps it to corresppnding degree on a servo
*Parameters: - value: temprature
*Returns: void
*/
void servoWrite(float value) {
  value = map(value, 22, 27, 0, 179);
  Serial.println(value);
  myservo.write(value);
}

/*
* This function prints the time to a 8-digit 7-secment display
*Parameters: void
*Returns: void
*/
void eightDigClock() {
  String time = getTime();

  for (int i = 0; i < 8; i++) {
    char digit = time[i];
    lc.setChar(0, 7-i, digit, false);
  }
}