#include "lib/erl_port.h"
#include "lib/bcm2835.h"

int main(void)
{
  bcm2835_init();
  erl_init(NULL, 0);
  byte buf[BUFSIZ];

  FILE *f = fopen("/sys/pix/dot", "w");

  int len, i;
  while((len = read_cmd(buf)) > 0)
  {
    for(i=0; i<len; i++)
    {
      int x = i % 16;
      int y = i / 16;
      int r = buf[i] & 0b001;
      int g = buf[i] & 0b010;
      int b = buf[i] & 0b100;

      fprintf(f, "%i %i %i %i %i\n", x, y, r, g, b);
      fflush(f);
    }
  }

  return 1;
}
