#!/bin/sh

if [ $# -eq 0 ]; then
    echo ""
    echo "Usage: $0 <frequency> <volume>"
    echo "   frequency: desired tone frequency in hertz (92 - 3000000)"
    echo "   volume: desired volume (0-100)"
    echo ""
    exit 1;
fi

FREQ=$1
VOL=$2

# PWM clock is 24Mhz/4 = 167ns
CLKPERIOD=167

# Volume PWM is fixed at 20Khz, duty cycle varies
PWMFREQ=20000

# calculate number of clocks on & off for desired volume
PERIOD1ON=`echo "1000000000/(2*$PWMFREQ)/$CLKPERIOD*$VOL/100" | bc`
PERIOD1OFF=`echo "1000000000/(2*$PWMFREQ)/$CLKPERIOD*(100-$VOL)/100" | bc`

# calculate number of clocks in a half cycle for desired frequency
PERIOD2=`echo "1000000000/(2*$FREQ)/$CLKPERIOD" | bc`

# set up pwm4 and pwm7 to use timer trigger
echo timer >  /sys/class/leds/beeper-pwm4/trigger
echo timer >  /sys/class/leds/beeper-pwm7/trigger

# program pwm4 on/off time for desired volume
echo $PERIOD1ON > /sys/class/leds/beeper-pwm4/delay_on
echo $PERIOD1OFF > /sys/class/leds/beeper-pwm4/delay_off

# program pwm7 on/off times for desired frequency
echo $PERIOD2 > /sys/class/leds/beeper-pwm7/delay_on
echo $PERIOD2 > /sys/class/leds/beeper-pwm7/delay_off
