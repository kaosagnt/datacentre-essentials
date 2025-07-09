## Final Project Bare Metal Server 3

### Bare Metal Server 3

```
Subnet Range: 192.168.10.0/24
VLAN: 10
Name: BMS03
Rack: AH310
Slot: 23
Type: HPE ProLiant Server DL360 Gen9
```

Documentation: <https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=1010007891&tab=driversAndSoftware&manualsFilter=66000035&driversAndSoftwareFilter=8000078>

```
Defaults:
	Username: Administrator
	DNS Name: ILOSGH614V4EJ
	Password: 11223344
Server Serial: SGH614V4EJ

SATA: 1 x 500GB Port 1 box 1 bay 1
RAID: 0
SET BOOTABLE LOGICAL VOLUME

192GB RAM
24 CPUs x Intel(R) Xeon(R) CPU E5-2673 v3 @ 2.40GHz

iLO: 192.168.99.52 / 24
iLO Gateway: 192.168.99.254 / 24
ilouser: !Tafe@nsw2025
```

Restful iLO tools: <https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=1010007891&tab=driversAndSoftware&manualsFilter=66000035&driversAndSoftwareFilter=8000093>

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
Port: 22
Cable: NS1P22
```

HP Switch Configuration:

```
configure
vlan 99
  tagged 22
  exit
exit
write memory
```

---
Cisco Switch Configuration

```
Fibre Switch: 1 (192.168.99.231)
Type: Cisco Nexus C3164Q 40GE
Port: 30
Cable: NS2P30
```

Configuration:

```
en
conf t
interface Ethernet 1/30
switchport mode access
switchport access vlan 10
exit
exit
copy run start
```

---
Windows Hyper-V 2019

```
Administrator: !Tafe@nsw2025

Name: BMS03
IPv4: 192.168.10.12 /24
Gateway: 192.168.10.254
AD Domain: dca.local
DNS: 192.168.10.20/24
2DNS: 192.168.10.21/24
VLAN: 10

Remote Management: enabled
Remote Desktop: enabled (all clients)

NIC Index: 2
Type: HP InfiniBand FDR 10/40GBE
```

HPE FDR InfiniBand Adapter Manual: <https://support.hpe.com/connect/s/product?language=en_US&kmpmoid=1008852053&tab=manuals>

---
Turn advanced Firewall on / off for testing

OFF:

	netsh advfirewall set allprofiles state off

ON:

	netsh advfirewall set allprofiles state on


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

Hyper-V Managment

sconfig Utility

[How to manage Hyper-V Server Core with Sconfig](https://www.bdrsuite.com/blog/manage-hyper-v-server-core-with-sconfig/)

[Configure a Server Core installation of Windows Server and Azure Local with the Server Configuration tool (SConfig)](https://learn.microsoft.com/en-us/windows-server/administration/server-core/server-core-sconfig)

Windows Remote Management (WinRM) port: 5985 TCP

---

SNMP Monitoring {#snmpmon}

<https://techwithjasmin.com/monitoring/install-and-configure-snmp-on-hyper-v-server-core/>

See if SNMP is installed and running

powershell:

	Get-WindowsFeature SNMP*


Install SNMP service:

	Install-WindowsFeature SNMP-Service

SNMP WMI Provider:

	Install-WindowsFeature SNMP-Service -IncludeAllSubFeature


Check if firewall rules added

	Get-NetFirewallRule -DisplayName "*SNMP*"


Configure SNMP Service

There are no PowerShell cmdlets for SNMP administration. Need to remotely access SNMP service from Server Manager or MMC (Microsoft Management Console) on the Windows server 2025.


Connect to one of the Windows Hyper-V 2019 Servers:

Open Server Manager (Services) and navigate to Tools > Services > Actions > Connect to another computer

Type the FQDN of your Hyper-V server and click OK to connect to it. Once you are connected, you can remotely configure SNMP.

Expand Services and navigate to SNMP Service and then Right click > Properties.

Click on the Security tab to configure community string and ACL.

Click on Add… under Community to create a community string.

Select Accept SNMP packets from these hosts and click Add… to add the IP of your NMS (Network Monitoring Solution).

```
community: craptrap

Trap Destinations:
192.168.10.30
192.168.10.31

Accept SNMP from hosts:
192.168.10.30
192.168.10.31
```

---

Zabbix Windows agent 2 v7.0.11 {#zbxmon}

```
Packaging:	MSI
Encryption:	No encryption
Linkage:	Static

Checksum:	
sha256:	b324fac33f1cabc272dcddb50b6ed1675642b1d719ac1c630052c34d83eddd7c
sha1: 800fab634d5dfcf9b572533a3ee8ce386f37ab84
md5: 43eee60f24e907504617132c79d8bf80

DOWNLOAD https://cdn.zabbix.com/zabbix/binaries/stable/7.0/7.0.11/zabbix_agent2_plugins-7.0.11-windows-amd64.msi
```

Manual:
<https://www.zabbix.com/documentation/7.0/en/manual/concepts/agent2>

<https://blog.zabbix.com/monitoring-windows-servers-with-zabbix-agent/29945/>

Configure host in Zabbix Server

To set up a host on Zabbix Server, go to the Zabbix frontend and go to Data collection > Hosts.

Then, click Create host (located in the top right) and configure the following details:

- The hostname (BMS03)
- An identifying display name (such as ‘Windows Server’)
- The template (select ‘Windows by Zabbix Agent’)
- The group (assigns the server to an appropriate group)
- The interface (choose the agent monitoring option and enter the IP of the server)

To install Zabbix Agent 2 client on Hyper-V host:

Map a network share to p: drive where the zabbix_agent2-7.0.11-windows-amd64-openssl.msi
lives.

	net use p: \\srv01\installation

Run msiexe.exe to automatically install the client.

	msiexec.exe /l*v "C:\zabbix\package.log" /i "p:\zabbix_agent2-7.0.11-windows-amd64-openssl.msi" /qn+ SERVER=192.168.10.30 ADDDEFAULT=ALL ADDLOCAL=ALL ENABLEPATH=1 LISTENPORT=10050

