#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "erl_interface.h"
#include "ei.h"

typedef unsigned char byte;

int read_cmd(byte *buf);
int write_cmd(byte *buf, int len);
int read_exact(byte *buf, int len);
int write_exact(byte *buf, int len);
