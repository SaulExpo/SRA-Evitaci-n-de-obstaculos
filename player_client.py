#!/usr/bin/env python


import math
from playerc import *

client = playerc_client(None, 'localhost', 6665)

if client.connect() != 0:
  raise playerc_error_str();

algorithm = playerc_position2d(client, 1)
if algorithm.subscribe(PLAYERC_OPEN_MODE) != 0:
  raise playerc_error_str()

for i in range(80):
  client.read()
  if algorithm.set_cmd_pose(0.0, 1.0, 0.0, 1) != 0:
    raise playerc_error_str()

algorithm.unsubscribe()
client.disconnect()
