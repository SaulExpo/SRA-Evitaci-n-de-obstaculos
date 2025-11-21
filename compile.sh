#!/bin/bash
g++ -o player_client `pkg-config --cflags playerc++` -std=c++0x  main.cc `pkg-config --libs playerc++`
