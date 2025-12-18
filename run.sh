#!/bin/bash

CFG_FILE="everything.cfg"
CLIENT="./player_client"

X=3.5
Y=1.2
YAW=0.0

RUNS=10          
PLAYER_PORT=6665
WAIT_PLAYER=2 
WAIT_END=2

for ((i=1; i<=RUNS; i++)); do

  player $CFG_FILE &
  PLAYER_PID=$!

  sleep $WAIT_PLAYER

  $CLIENT $X $Y $YAW localhost $PLAYER_PORT

  echo "Run $i finished"

  kill $PLAYER_PID
  wait $PLAYER_PID 2>/dev/null

  sleep $WAIT_END
done

echo "All finished."
