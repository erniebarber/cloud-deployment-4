#!/bin/bash
for y in range (15):
  addr = "192.168.1." + str(y+1)
  ssh-keyscan -H addr >> ~/.ssh/known_hosts
  ssh addr -f 'sleep 5'

#ssh-keyscan -H 192.168.1.2 >> ~/.ssh/known_hosts
#ssh 192.168.1.2 -f 'sleep 5'
#ssh-keyscan -H 192.168.1.3 >> ~/.ssh/known_hosts
#ssh 192.168.1.3 -f 'sleep 5'
#ssh-keyscan -H 192.168.1.4 >> ~/.ssh/known_hosts
#ssh 192.168.1.4 -f 'sleep 5'
#ssh-keyscan -H 192.168.1.5 >> ~/.ssh/known_hosts
#ssh 192.168.1.5 -f 'sleep 5'
#ssh-keyscan -H 192.168.1.6 >> ~/.ssh/known_hosts
#ssh 192.168.1.6 -f 'sleep 5'
