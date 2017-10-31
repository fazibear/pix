#include <linux/init.h>
#include <linux/module.h>
//#include <linux/device.h>
#include <linux/kthread.h>
#include <linux/delay.h>
#include <linux/gpio.h>

MODULE_LICENSE("GPL");

/* GPIO */

#define A1  17 // 0
#define A2  18 // 1
#define A3  27 // 2
#define OE  22 // 3
#define LE  23 // 4
#define SDI 24 // 5
#define CLK 25 // 6

#define LINES 8
#define PER_LINE 12

static u8 pix_screen[LINES][PER_LINE] = {
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

void pix_line(u8 row){
  gpio_set_value(A1, !(row & 0b00000001));
  gpio_set_value(A2, !(row & 0b00000010));
  gpio_set_value(A3, !(row & 0b00000100));
}

void pix_dot(int x, int y, int r, int g, int b) {
  uint8_t l,p,t;

  if(y % 2){
    x = (x + 16);
  }
  y = (y / 2) - ((y / 2) % 1);

  l = x / 8;
  p = 7 - x % 8;
  t = pix_screen[y][l];

  //printf("line:%i, l:%i, p:%i, t:%i\n", y,l,p,t);

  if(g) {
    t |= 1 << p;
  }else{
    t &= ~(1 << p);
  }
  pix_screen[y][l] = t;

  l = x / 8 + 4;
  p = 7 - x % 8;
  t = pix_screen[y][l];
  if(b) {
    t |= 1 << p;
  }else{
    t &= ~(1 << p);
  }
  pix_screen[y][l] = t;

  l = x / 8 + 8;
  p = 7 - x % 8;
  t = pix_screen[y][l];
  if(r) {
    t |= 1 << p;
  }else{
    t &= ~(1 << p);
  }
  pix_screen[y][l] = t;
}

void pix_gpio_init(void){
  printk(KERN_INFO "PIX: starting gpio...");
  gpio_request(A1, "A1");
  gpio_request(A2, "A2");
  gpio_request(A3, "A3");

  gpio_request(OE, "OE");
  gpio_request(LE, "LE");
  gpio_request(SDI, "SDI");
  gpio_request(CLK, "CLK");

  gpio_direction_output(A1, 0);
  gpio_direction_output(A2, 0);
  gpio_direction_output(A3, 0);

  gpio_direction_output(OE, 1);
  gpio_direction_output(LE, 0);
  gpio_direction_output(SDI, 0);
  gpio_direction_output(CLK, 0);
  printk(KERN_INFO "PIX: starting gpio done.");
}

void pix_gpio_exit(void){
  printk(KERN_INFO "PIX: stopping gpio...");
  gpio_free(A1);
  gpio_free(A2);
  gpio_free(A3);

  gpio_free(OE);
  gpio_free(LE);
  gpio_free(SDI);
  gpio_free(CLK);
  printk(KERN_INFO "PIX: stopping gpio done.");
}



/* SYSFS */

static struct kobject *pix_kobject;

static ssize_t set_pix(struct kobject *kobj, struct kobj_attribute *attr, const char *buff, size_t count) {
  u8 x = 0;
  u8 y = 0;
  u8 r = 0;
  u8 g = 0;
  u8 b = 0;
  sscanf(buff, "%hhd %hhd %hhd %hhd %hhd", &x, &y, &r, &g, &b);

  pix_dot(x,y,r,g,b);
  // printk(KERN_INFO "PIX: %d %d %d %d %d", x,y,r,g,b);

  return count;
}

static struct kobj_attribute pix_attribute =__ATTR(dot, (S_IWUSR | S_IRUGO), NULL, set_pix);

void pix_sysfs_init(void){
  printk(KERN_INFO "PIX: starting sysfs...");
  pix_kobject = kobject_create_and_add("pix", NULL);
  if (sysfs_create_file(pix_kobject, &pix_attribute.attr)) {
    pr_debug("failed to create pix sysfs!\n");
  }
  printk(KERN_INFO "PIX: starting sysfs done.");
}

void pix_sysfs_exit(void){
  printk(KERN_INFO "PIX: stopping sysfs...");
  kobject_put(pix_kobject);
  printk(KERN_INFO "PIX: stopping sysfs done.");
}


/* THREAD */

#define THREAD_PRIORITY 1
#define THREAD_NAME "pix"

struct task_struct *task;

int pix_thread(void *data){
  u8 line, pos, bit;
  struct task_struct *TSK;
  struct sched_param PARAM = { .sched_priority = MAX_RT_PRIO };
  TSK = current;

  PARAM.sched_priority = THREAD_PRIORITY;
  sched_setscheduler(TSK, SCHED_FIFO, &PARAM);

  while(1) {
    for(line = 0; line < LINES; line++) {
      pix_line(line);
      for(pos = 0; pos < PER_LINE; pos++) {
        for (bit = 0; bit < 8; bit++)  {
            gpio_set_value(SDI, !!(pix_screen[line][pos] & (1 << (7 - bit))));
            gpio_set_value(CLK, 1);
            gpio_set_value(CLK, 0);
        }
      }
      gpio_set_value(LE, 1);
      gpio_set_value(LE, 0);
      gpio_set_value(OE, 0);
      usleep_range(2000, 2000);
      gpio_set_value(OE, 1);
    }
    if (kthread_should_stop()) break;
  }
  return 0;
}

void pix_thread_init(void){
  printk(KERN_INFO "PIX: starting thread...");
  task = kthread_run(pix_thread, NULL, THREAD_NAME);
  printk(KERN_INFO "PIX: starting thread done.");
}

void pix_thread_exit(void){
  printk(KERN_INFO "PIX: stopping thread...");
  kthread_stop(task);
  printk(KERN_INFO "PIX: stopping thread done.");
}

/* MODULE */

static int __init pix_init(void){
  printk(KERN_INFO "PIX: staring...");
  pix_gpio_init();
  pix_thread_init();
  pix_sysfs_init();
  printk(KERN_INFO "PIX: staring done.");
  return 0;
}

static void __exit pix_exit(void){
  printk(KERN_INFO "PIX: stopping...");
  pix_sysfs_exit();
  pix_thread_exit();
  pix_gpio_exit();
  printk(KERN_INFO "PIX: stopping done.");
}

module_init(pix_init);
module_exit(pix_exit);
