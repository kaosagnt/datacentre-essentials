# Set the Windows Server Network Time Protocol (NTP) Server

As the TAFE Datacentre network configuration, at the time of the course, did
not have any external network access to the outside world aka the internet,
a local time server was made available for use.

NTP server IPv4 192.168.99.1/24

## Changing Windows Server NTP Settings

	net stop w32time
	w32tm /config /syncfromflags:manual /manualpeerlist:"192.168.99.1" /reliable:yes
	net start w32time
	w32tm /config /update
	w32tm /resync /rediscover

A batch (bat) file in the scripts directory is available to set the time
server.

[set-net-time.bat](./scripts/set-net-time.bat)

NOTE: The NTP server must be changed before the Windows Server is made an Active Directory (AD) Server.

## How to check if the  NTP server is working?

From a command(cmd) prompt:

	w32tm /query /status


## Reference list

UMATechnology 2025, *How to configure NTP Server on Windows Server - UMA Technology*, UMA Technology, viewed 17 June 2025, <<https://umatechnology.org/how-to-configure-ntp-server-on-windows-server/>>.

