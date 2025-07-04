@echo off

net stop w32time
w32tm /config /syncfromflags:manual /manualpeerlist:"192.168.99.1" /reliable:yes
net start w32time
w32tm /config /update
w32tm /resync /rediscover
