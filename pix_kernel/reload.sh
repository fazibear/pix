#!/bin/bash

# make clean
make 
sudo rmmod pix_mod
sudo insmod pix_mod.ko
