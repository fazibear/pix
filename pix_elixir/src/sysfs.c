#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "erl_comm.h"

int main(void)
{
  erl_init(NULL, 0);
  byte buf[BUFSIZ];

  while((read_cmd(buf)) > 0)
  {
    ETERM *arr[2], *tuple;
    int i;
    arr[0] = erl_mk_atom("tobbe");
    arr[1] = erl_mk_int(3928);
    tuple = erl_mk_tuple(arr, 2);
    i = erl_encode(tuple, buf);

    write_cmd(buf, i);
  }

  return 1;
}
