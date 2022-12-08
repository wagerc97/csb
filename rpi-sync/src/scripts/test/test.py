#!/usr/bin/python

import time
from datetime import datetime

tsh = datetime.now()

ts = str(tsh).split('.')[0]

print(tsh , "hello world")
time.sleep(3)
