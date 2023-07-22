#include <pthread.h>
#include <sched.h>
#include <time.h>
#include "lib/erl_port.h"
#include "lib/bcm2835.h"

#define A1  17 // 0
#define A2  18 // 1
#define A3  27 // 2
#define OE  22 // 3
#define LE  23 // 4
#define SDI 24 // 5
#define CLK 25 // 6

#define LINES 8
#define PER_LINE 12

#define SET_GPIO(pin, value) bcm2835_gpio_write(pin, value)
#define SET_GPIO_OUT(pin) bcm2835_gpio_fsel(pin, BCM2835_GPIO_FSEL_OUTP)
#define USLEEP(time) bcm2835_delayMicroseconds(time)

#ifdef linux
#include <sys/mman.h>
void set_realtime()
{
    struct sched_param sp;
    memset(&sp, 0, sizeof(sp));
    sp.sched_priority = 40; //sched_get_priority_max(SCHED_FIFO); //40;
    sched_setscheduler(0, SCHED_FIFO, &sp);
    mlockall(MCL_CURRENT | MCL_FUTURE);
}
#endif

/* struct timespec ts; */
/* static void sleep_until(int delay) */
/* { */
/*     ts.tv_nsec += delay; */
/*     if(ts.tv_nsec >= 1000*1000*1000) { */
/*         ts.tv_nsec -= 1000*1000*1000; */
/*         ts.tv_sec++; */
/*     } */
/*     clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL); */
/* } */

uint8_t matrix[LINES][PER_LINE] = {
    {
        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b10000000,0b00000001,
        0b00000000,0b00000000,
    },
    {
        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b00000000,0b00000000,
        0b00000000,0b00000000,
    },
    {
        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b00000000,0b00000000,
        0b00000000,0b00000000,
    },
    {
        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b00000000,0b00000000,
        0b00000000,0b00000000,
    },
    {
        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b00000000,0b00000000,
        0b00000000,0b00000000,
    },
    {
        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b00000000,0b00000000,
        0b00000000,0b00000000,
    },
    {
        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b00000000,0b00000000,
        0b00000000,0b00000000,
    },
    {
        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b00000000,0b00000000,
        0b00000000,0b00000000,

        0b00000000,0b00000000,
        0b10000000,0b00000001,
    },
};

void set_line(uint8_t row)
{
    SET_GPIO(A1, !(row & 0b00000001));
    SET_GPIO(A2, !(row & 0b00000010));
    SET_GPIO(A3, !(row & 0b00000100));
}

void gpio_init(void)
{
    SET_GPIO_OUT(A1);
    SET_GPIO_OUT(A2);
    SET_GPIO_OUT(A3);

    SET_GPIO_OUT(OE);
    SET_GPIO_OUT(LE);
    SET_GPIO_OUT(SDI);
    SET_GPIO_OUT(CLK);
}

void set_dot(int x, int y, int r, int g, int b)
{
    uint8_t l,p,t;

    if(y % 2) {
        x = (x + 16);
    }
    y = (y / 2) - ((y / 2) % 1);

    l = x / 8;
    p = 7 - x % 8;
    t = matrix[y][l];

    //printf("line:%i, l:%i, p:%i, t:%i\n", y,l,p,t);

    if(g) {
        t |= 1 << p;
    } else {
        t &= ~(1 << p);
    }
    matrix[y][l] = t;

    l = x / 8 + 4;
    p = 7 - x % 8;
    t = matrix[y][l];
    if(b) {
        t |= 1 << p;
    } else {
        t &= ~(1 << p);
    }
    matrix[y][l] = t;

    l = x / 8 + 8;
    p = 7 - x % 8;
    t = matrix[y][l];
    if(r) {
        t |= 1 << p;
    } else {
        t &= ~(1 << p);
    }
    matrix[y][l] = t;
}

void draw()
{
    uint8_t line, pos, bit;

    while(1) {
        for(line = 0; line < LINES; line++) {
            set_line(line);
            for(pos = 0; pos < PER_LINE; pos++) {
                for (bit = 0; bit < 8; bit++)  {
                    SET_GPIO(SDI, !!(matrix[line][pos] & (1 << (7 - bit))));
                    SET_GPIO(CLK, 1);
                    SET_GPIO(CLK, 0);
                }
            }
            SET_GPIO(LE, 1);
            SET_GPIO(LE, 0);
            SET_GPIO(OE, 0);
            USLEEP(2000);
            //sleep_until(2000000);
            SET_GPIO(OE, 1);
        }
    }
}

void* cmd()
{
    int len, i;
    byte buf[BUFSIZ];

    while((len = read_cmd(buf)) > 0) {
        for(i=0; i<len; i++) {
            int x = i % 16;
            int y = i / 16;
            int r = buf[i] & 0b001;
            int g = buf[i] & 0b010;
            int b = buf[i] & 0b100;

            set_dot(x, y, r, g, b);
        }
    }
}

int main(void)
{
    pthread_t cmd_thread;

    set_realtime();

    /* clock_gettime(CLOCK_MONOTONIC, &ts); */

    bcm2835_init();
    gpio_init();

    pthread_create(&cmd_thread, NULL, cmd, NULL);

    draw();

    bcm2835_close();
    return 1;
}
