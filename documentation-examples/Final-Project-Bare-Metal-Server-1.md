## Final Project Bare Metal Server 1

### Bare Metal Server 1

```
Subnet Range: 192.168.10.0/24
VLAN: 10
Name: BMS01
Rack: AH310
Slot: 21
Type: HPE ProLiant Server DL360 Gen9

```

Documentation: [https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=1010007891&tab=driversAndSoftware&manualsFilter=66000035&driversAndSoftwareFilter=8000078](https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=1010007891&tab=driversAndSoftware&manualsFilter=66000035&driversAndSoftwareFilter=8000078)

```
Defaults:
	Username: Administrator
	DNS Name: ILOSGH614V4FJ
	Password: 11222333
	Server Serial: SGH614V4FJ

SATA: 1 x 500GB Port 1 box 1 bay 1
RAID: 0
SET BOOTABLE LOGICAL VOLUME

192GB RAM
24 CPUs x Intel(R) Xeon(R) CPU E5-2673 v3 @ 2.40GHz

iLO: 192.168.99.50 / 24
iLO Gateway: 192.168.99.254 / 24
ilouser: !Tafe@nsw2025
```

Restful iLO tools: [https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=1010007891&tab=driversAndSoftware&manualsFilter=66000035&driversAndSoftwareFilter=8000093](https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=1010007891&tab=driversAndSoftware&manualsFilter=66000035&driversAndSoftwareFilter=8000093)

```
Additional Drivers:

Broadcom NIC.exe
HP Array Config Utility.exe
HP Chipset identifier.exe
HP QLogic 10-25-50GbE driver.exe
iLO 4 Channel Interface driver.exe
iLO 4 Management Controller driver.exe
Matrox G200 Video Drivers.exe
Smart Array Controller HPCISSS3.exe
Smart Array Controller.exe
Storage Fibre channel over ETH.exe
```

---
iLO Switch Configuration

```
iLO Switch: 3 (192.168.99.233)
Type: HP2530 48 Port
Port: 20
Cable: NS1P20
```

HP Switch Configuration:

```
configure
vlan 99
  tagged 20
  exit
exit
write memory
```

---
Cisco Switch Configuration

```
Fibre Switch: 1 (192.168.99.231)
Type: Cisco Nexus C3164Q 40GE
Port: 28
Cable: NS2P28
```

Configuration:

```
en
conf t
interface Ethernet 1/28
switchport mode access
switchport access vlan 10
exit
exit
copy run start
```

---

Windows Server 2025

```
local Administrator: !Tafe@nsw2025

IPv4: 192.168.10.20 / 24
Gateway: 192.168.10.254
VLAN: 10

Interface: HP InfiniBand FDR/Ethernet 10GB/40GB 2 port 544+ FLR-QS Ethernet Adapter
Embedded Flexible LOM Port: 1
```

HPE FDR InfiniBand Adapter Manual: [https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=1008852053&tab=manuals](https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=1008852053&tab=manuals)

```
Additional Drivers:

Broadcom NIC.exe
HP Array Config Utility.exe
HP Chipset identifier.exe
HP QLogic 10-25-50GbE driver.exe
iLO 4 Channel Interface driver.exe
iLO 4 Management Controller driver.exe
Matrox G200 Video Drivers.exe
Smart Array Controller HPCISSS3.exe
Smart Array Controller.exe
Storage Fibre channel over ETH.exe
```

---

Active Directory

```
Administrator: !Tafe@nsw2025

Name: SRV01
DNS Name: SRV01.dca.com.au

AD: dca.local

DNS: enabled
Global Catalog: enabled

DSRM Password: Route2025!

Create DNS Delegation: yes
Netbios name: DCA
```

---

UNP suffix: dca.com.au

Active Directory, you can add additional (alternative) UPN suffixes using the Active Directory Domains and Trusts graphic console or PowerShell.

Powershell Console:

	Get-ADForest | Format-List UPNSuffixes

If the list is empty, it means that you are using a default UPN suffix matching your DNS domain name.

To add an alternative UPN suffix:

	Get-ADForest | Set-ADForest -UPNSuffixes @{add="dca.com.au"}

---

Open ICMP port for ping (IPv4) for testing connectivity

Powershell Console:
 
	New-NetFirewallRule -Name 'ICMPv4' -DisplayName 'ICMPv4' -Description 'Allow ICMPv4 Ping' -Profile Any -Direction Inbound  -Action Allow -Protocol ICMPv4 -Program Any -LocalAddress Any -RemoteAddress Any 

Check rule

	Get-NetFirewallRule | Where-Object Name -Like 'ICMPv4'

Enable rule:

	Enable-NetFirewallRule -Name 'ICMPv4'

Disable rule:

	Disable-NetFirewallRule -Name 'ICMPv4'

---

Add Hyper-V management tools not as a Role
Just for Hyper-V Manager to connect to remote servers.

Powershell Console:

	add-windowsfeature rsat-hyper-v-tools


---

DHCP

```
Name: 192.168.10.0
Scope:
	start: 	192.168.10.100
	end:	192.168.10.120

	length: 24
	mask:	255.255.255.0

	duration: 8 days 0 hrs 0 sec

	router(default gateway): 192.168.10.254

	Time Server: 192.168.99.1

	parent domain: dca.com.au

	DNS:	192.168.10.20
	2DNS: 192.168.10.21
```

---

DNS dca.com.au

Add Hosts

```
	srv01.dca.com.au (192.168.10.20)
	srv02.dca.com.au (192.168.10.21)
	hyperv01.dca.com.au (192.168.10.22)
	hyperv02.dca.com.au (192.168.10.23)
	nas01.dca.com.au (192.168.10.24)

	monitor01.dca.com.au (192.168.10.30)
		cname: zabbix01.dca.com.au

	monitor02.dca.com.au (192.168.10.31)
		cname: nagios01.dca.com.au
```

---
SNMP

```
SNMP Service: installed / running
community: craptrap

Trap Destinations:
192.168.10.30
192.168.10.31

Send Auth:
accepted community name: craptrap / RO
``

Accept SNMP from hosts:
192.168.10.30
192.168.10.31
```

---

Nagios Monitoring

Installation Instructions:
[https://assets.nagios.com/downloads/ncpa/docs/Installing-NCPA.pdf](https://assets.nagios.com/downloads/ncpa/docs/Installing-NCPA.pdf)

NCPA Client

```
Token: 7e4dbbad854c285
Log Level: warning
Bind IP: 0.0.0.0
Bind Port: 5693
SSL: TLSv1_2
```

NRDP Configuration

```
Send Passive Checks: enabled

URL:
NRDP Token:

Check Interval: 300 seconds
```


