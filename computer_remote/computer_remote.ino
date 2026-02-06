/*
* Name: Computer_remote
* Author: Jonathan Wikund
* Date: 2026-03-06 yyyy-mm-dd
* Description: This program uses a 3x4 matrix keypad to type letters A-Z, and a joystick to move the mouse, on a computer.
*/
#include <Keypad.h>
#include <Keyboard.h>
#include <Mouse.h>

//joystick constants
const uint8_t JOYSTICK_X_PIN = A2;
const uint8_t JOYSTICK_Y_PIN = A3;
const uint8_t deadzone = 50;
unsigned long mouseCounter = 0;
const int mouseSpeed = 25;
float joystickMax = 1023;
float joystickHalf = joystickMax / 2;

//variables
int mode = 0;
int modeCounter = 3 - 1;
unsigned long oldTime = 0;

//keypad constants
const char switcherKey = '<';
extern const uint8_t KeyboardLayout_sv_SE[];
const unsigned long wait_time = 800;
#define KEY_SPACE 0x20

//keypad variables
unsigned long time_previous_button_press;
unsigned long time_current_button_press;
char key;
char last_x = -1;
int x = 0;
int y = 0;
long temp = 0;
bool writing = 0;
bool write_again = 0;

char alphabet[12][5] = {
  { '1', '1', '1', '1', '<' },
  { 'A', 'B', 'C', '2', '<' },
  { 'D', 'E', 'F', '3', '<' },
  { 'G', 'H', 'I', '4', '<' },
  { 'J', 'K', 'L', '5', '<' },
  { 'M', 'N', 'O', '6', '<' },
  { 'P', 'Q', 'R', 'S', '7' },
  { 'T', 'U', 'V', '8', '<' },
  { 'W', 'X', 'Y', 'Z', '9' },
  { KEY_BACKSPACE, '<' },
  { KEY_SPACE, '<' },
  { '#', '#', '#', '#', '#' }
};

const byte ROWS = 4;  //four rows
const byte COLS = 3;  //three columns
char keys[ROWS][COLS] = {
  { '1', '2', '3' },
  { '4', '5', '6' },
  { '7', '8', '9' },
  { ':', ';', '<' }  //the next values in the ascii table making indexes 9, 10, 11 respectivly
};

byte rowPins[ROWS] = { 5, 4, 3, 2 };  //connect to the row pinouts of the keypad
byte colPins[COLS] = { 8, 7, 6 };     //connect to the column pinouts of the keypad

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

void setup() {
  Serial.begin(9600);
  Mouse.begin();
  Keyboard.begin();
}

void loop() {
  mouseCounter = mouseCounter + getDeltaTime();

  if (mouseCounter >= 30) {  //used to slow down the mouse
    mouse_movment();
    mouseCounter = 0;
  }

  char key = keypad.getKey();

  if (key == switcherKey) {
    switchMode();
    Serial.println(switchMode());
  }

  if (mode == 1 && key != switcherKey) {
    Keyboard.write(key);
  }

  if (mode == 0) {  // && key != switcherKey) {

    write_keypad();


    if (key) {

      Serial.print(x);
      Serial.print(" ");
      Serial.println(mode);
    }
  }
}

/*
* This function reads the joystick x and y value and moves the mouse pointer of the computer
* Parameters: none
* Returns: void
*/
void mouse_movment() {
  float joystick_x = analogRead(JOYSTICK_X_PIN) - joystickHalf;  // -512 to 512
  float joystick_y = analogRead(JOYSTICK_Y_PIN) - joystickHalf;

  // apply deadzone
  if (joystick_x < deadzone && joystick_x > -deadzone) {
    joystick_x = 0;
  }
  if (joystick_y < deadzone && joystick_y > -deadzone) {
    joystick_y = 0;
  }

  float c = getMagnitude(joystick_x, joystick_y);
  float percentX = abs(joystick_x) / joystickHalf;
  float percentY = abs(joystick_y) / joystickHalf;

  float newX = (joystick_x / c) * percentX * mouseSpeed;
  float newY = (joystick_y / c) * percentY * mouseSpeed;

  if (joystick_x == 0 && joystick_y == 0) {
    newX = joystick_x;
    newY = joystick_y;
  }

  if (newX < 1 && newX > 0) {
    newX = 1;
  }

  if (newY < 1 && newY > 0) {
    newY = 1;
  }

  Mouse.move(newX, newY);
}

/*
  * This function uses millis() to get the time diffrense
  * Parameters: none
  * Returns: float
  */
int getDeltaTime() {
  unsigned long currentTime = millis();
  unsigned long deltaTime = currentTime - oldTime;
  oldTime = currentTime;
  //Serial.println(deltaTime);
  return deltaTime;
}

/*
* This function takes an x and y and returns the hypotenyse
* Parameters: -value: float x and float y: ...
* Returns: float 
*/
float getMagnitude(float x, float y) {
  return sqrt(x * x + y * y);
}

/*
* This function swtches the mode that the keypad writes
* Parameters: none
* Returns: int
*/
int switchMode() {
  mode = mode + 1;

  if (mode > modeCounter) {
    mode = 0;
  }
  return mode;
}

/* 
* This function cycles though the alphabet letter options and writes letters
* Parameters: none
* Returns: void
*/
void write_keypad() {
  delay(1);
  key = keypad.getKey();

  if (key) {
    writing = 1;
    temp = millis();
    y = 0;
    x = key - '1';

    if (x >= 9 && x <= 11) {
      writing = 1;
      temp = millis() + wait_time;
    }
    last_x = x;
  }

  while (millis() - temp <= wait_time) {

    key = keypad.getKey();
    if (key) {
      x = key - '1';

      if (x >= 9 && x <= 11) {
        break;
        Serial.println("banan");
      }

      if (x == last_x || last_x == -1) {
        y++;
        temp = millis();

        if (y >= 5 || alphabet[x][y] == '<') {
          y = 0;
        }

        Serial.println(alphabet[x][y]);

      } else {
        x = last_x;
        Serial.print("write: ");
        Serial.println(alphabet[x][y]);
        Keyboard.write(alphabet[x][y]);
        Serial.println("writing again...");
        temp = millis();
        y = 0;
        x = key - '1';
        last_x = x;
        writing = 1;
      }
    }
  }

  if (writing) {
    Serial.print("write: ");
    Serial.println(alphabet[x][y]);
    Keyboard.write(alphabet[x][y]);
    writing = 0;
  }
}