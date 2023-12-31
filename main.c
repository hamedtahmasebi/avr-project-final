#include <mega16a.h>
#include <lcd.h>


#asm 
 .equ __lcd_port=0x15; 
#endasm

#include <delay.h>
#define IS_ON_LED_OUT PORTD .6
#define ALARM_OUT PORTD .5
#define IS_SENSOR_PAUSED_LED PORTD .7
#define KEYPAD_PIN PINB
#define KEYPAD_PORT PORTB
#define KEYPAD_ENABLE_PIN PINA .4
#define REMOTE_PIN PINA
int PAUSE_TIME_AFTER_DISCARD_SECONDS = 5;

typedef enum
{
  rmt_no_action, // Do nothing, prevents default behaviour of enums.
  rmt_turn_on,
  rmt_turn_off,
  rmt_discard_alarm,
} eRemoteAction;

bit is_remote_locked = 0; // if remote is locked programmatically using keypad
void temporarily_pause_sensor()
{
  // with prescale set to 1024 and clk frequency = 1MHz, timer counts almost 1ms each clock.
  int timer_bottom = (65 - PAUSE_TIME_AFTER_DISCARD_SECONDS) * 1000;
  IS_SENSOR_PAUSED_LED = 1;
  TCNT1 = timer_bottom;
  TCCR1B |= 0x05; // prescale set to 5 -> 1MHz / 1024 ~= 1ms
}

void handle_remote_action(eRemoteAction rmt_action)
{
  if (rmt_action == rmt_no_action)
    return;

  if (rmt_action == rmt_turn_on)
  {
    IS_ON_LED_OUT = 1;
  }
  if (rmt_action == rmt_turn_off)
  {
    IS_ON_LED_OUT = 0;
    ALARM_OUT = 0;
  }
  if (rmt_action == rmt_discard_alarm)
  {
    ALARM_OUT = 0;
    temporarily_pause_sensor();
  }
}


const char KEYPAD_MATRIX[4][3] = {
    {'1', '2', '3'}, {'4', '5', '6'}, {'7', '8', '9'}, {'*', '0', '#'}};

typedef enum
{
  kp_no_action,
  kp_turn_on,
  kp_turn_off,
  kp_lock_remote,
  kp_unlock_remote,
  kp_discard_alarm
} eKeypadAction;

char read_keypad()
{
  char key = 0;

  while (1)
  {
    int i, j;
    if (KEYPAD_ENABLE_PIN == 0)
    {
      break;
    }

    for (i = 0; i < 3; i++)
    {
      // Set one column low at a time
      KEYPAD_PORT |= 0x0F;
      KEYPAD_PORT &= ~(1 << i);

      delay_ms(5);

      // Check rows
      for (j = 0; j < 4; j++)
      {
        if (!(KEYPAD_PIN & (1 << (j + 4))))
        {
          // Key pressed
          key = KEYPAD_MATRIX[j][i];
          while (!(KEYPAD_PIN & (1 << (j + 4))))
            ; // Wait for key release
          return key;
        }
      }
    }
  }
}

void handle_keypad_action(eKeypadAction action)
{
  if (action == kp_no_action)
    return;
  if (action == kp_turn_on)
  {
    IS_ON_LED_OUT = 1;
  }

  if (action == kp_turn_off)
  {
    IS_ON_LED_OUT = 0;
    ALARM_OUT = 0;
  }

  if (action == kp_lock_remote)
  {
    is_remote_locked = 1;
  }

  if (action == kp_unlock_remote)
  {
    is_remote_locked = 0;
  }
  if (action == kp_discard_alarm)
  {
    ALARM_OUT = 0;
    temporarily_pause_sensor();
  }
}

void lcd_render_guide()
{
  lcd_clear();
  lcd_gotoxy(0, 0);
  delay_ms(10);
  lcd_puts("1:on 2:off");
  delay_ms(15);
  lcd_gotoxy(0, 1);
  delay_ms(15);
  lcd_puts("3:lock 4:unlock");
}

interrupt[2] void trigger_alarm()
{
  if (IS_ON_LED_OUT == 1 && !IS_SENSOR_PAUSED_LED)
  {
    ALARM_OUT = 1;
  } else {
  return;
  }
}

interrupt[TIM1_OVF] void exit_silent_mode()
{
  TCCR1B = 0x00; // turn off the timer
  IS_SENSOR_PAUSED_LED = 0;
  ALARM_OUT = 0;
  IS_SENSOR_PAUSED_LED = 0;  
}


void main()
{
#asm("sei")    // Enable interrupt
  DDRA = 0x00; // Input
  DDRB = 0x0f; // Keypad Set columns as output and rows as input
  PORTB = 0xf0;
  DDRC = 0xff;
  PORTC = 0x00;
  DDRD = 0b11100000; // Output
  PORTD = 0b01000000;
  GICR = 0b01000000;  // Enabling interrupt 0
  MCUCR = 0b00000011; // Rising Edge
  GIFR = 0b0000000;
  IS_ON_LED_OUT = 1;
  ALARM_OUT = 0;
  TIMSK |= (1 << TOIE1); // Enable Timer1 Overflow
  
  lcd_init(16);
  delay_ms(10);
  lcd_render_guide();
  delay_ms(10);
  while (1)
  {
    eRemoteAction rmt_action = rmt_no_action;
    
    if (REMOTE_PIN .0 == 1)
    {
      rmt_action = rmt_turn_on;
    }

    if (REMOTE_PIN .1 == 1)
    {
      rmt_action = rmt_turn_off;
    }

    if (REMOTE_PIN .2 == 1)
    {
      rmt_action = rmt_discard_alarm;
    }

    if (is_remote_locked != 1)
    {
      handle_remote_action(rmt_action);
    }

    if (KEYPAD_ENABLE_PIN == 1)
    {

      eKeypadAction keypad_action = kp_no_action;
      char pressed_key;
      pressed_key = read_keypad();
      if (pressed_key == '1')
      {
        keypad_action = kp_turn_on;
      }
      if (pressed_key == '2')
      {
        keypad_action = kp_turn_off;
      }
      if (pressed_key == '3')
      {
        keypad_action = kp_lock_remote;
      }
      if (pressed_key == '4')
      {
        keypad_action = kp_unlock_remote;
      }
      if (pressed_key == '5')
      {
        keypad_action = kp_discard_alarm;
      }
      handle_keypad_action(keypad_action);
    }

  }
}