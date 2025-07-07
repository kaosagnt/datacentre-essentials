# Data Centre Essentials Powershell

## Restart Network Adapters

Restarts a network adapter by disabling and then re-enabling the network adapter.

	Restart-NetAdapter *.

---

## Open ICMP port for ping (IPv4) for testing connectivity

All profiles (Public, Private, Domain), all IPv4 addresses. For IPv6, change the protocol to -Protocol ICMPv6
 
	New-NetFirewallRule -Name 'ICMPv4' -DisplayName 'ICMPv4' -Description 'Allow ICMPv4 Ping' -Profile Any -Direction Inbound  -Action Allow -Protocol ICMPv4 -Program Any -LocalAddress Any -RemoteAddress Any 

Check if the rule exists

	Get-NetFirewallRule | Where-Object Name -Like 'ICMPv4'

Enable / Disable rule

	Enable-NetFirewallRule -Name 'ICMPv4'


	Disable-NetFirewallRule -Name 'ICMPv4'


---

## Add Hyper-V management tools not as a Role

Just for the Hyper-V Manager to connect to remote servers.


	add-windowsfeature rsat-hyper-v-tools

---

## SSH Remoting

Note: The Following is only required if your using Powershell on Linux to do Remote Windows support or want to manage Windows with SSH.

SSH remoting lets you do basic PowerShell session remoting between Windows and Linux computers. SSH remoting creates a PowerShell host process on the target computer as an SSH subsystem.

The New-PSSession, Enter-PSSession, and Invoke-Command cmdlets now have a new parameter set to support SSH remoting connections.

	[-HostName <string>]  [-UserName <string>]  [-KeyFilePath <string>]

To create a remote session, specify the target computer with the HostName parameter and the UserName parameter. When running cmdlets interactively, you're prompted for a password, unless the SSH key authentication with a private key file is used with the KeyFilePath parameter.

Manage Windows with OpenSSH
https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_overview

---

## Start an Interactive session on a Remote Computer

To start an interactive session with a single remote computer, use the Enter-PSSession cmdlet:

	Enter-PSSession <Name_of_Server>

The command prompt changes to display the name of the remote computer. Any commands that you type at the prompt run on the remote computer and the results are displayed on the local computer.

To end the interactive session:

	Exit-PSSession

---

## General Powershell

See all available registered module repositories

	Get-PSRepository


	Get-Module -ListAvailable

---

## Hyper-V

Install only the PowerShell module

	Install-WindowsFeature -Name Hyper-V-PowerShell

Install Hyper-V Manager and the PowerShell module (HVM only available on GUI systems)

	Install-WindowsFeature -Name RSAT-Hyper-V-Tools


## Checking VM Status

To check the status of a VM, use the Get-VM command. If you’re running this from a Linux system, ensure you’ve established a remote session to your Hyper-V host:

	Get-VM -Name "VMName"

[PowerShell Get VM](https://powershellcommands.com/powershell-get-vm) [https://powershellcommands.com/powershell-get-vm](https://powershellcommands.com/powershell-get-vm)

To start a VM:

	Start-VM -Name "VMName"

To stop a VM:

	Stop-VM -Name "VMName"

To create a new VM:

	New-VM -Name "NewVMName" -MemoryStartupBytes 2GB -BootDevice VHD -Path "path/to/vhdx" -Generation 2

To remove a VM:

	Remove-VM -Name "VMName" -Force


---

# References

Running Remote Commands
https://learn.microsoft.com/en-us/powershell/scripting/security/remoting/running-remote-commands?view=powershell-7.5

PowerShell remoting over SSH
https://learn.microsoft.com/en-us/powershell/scripting/security/remoting/ssh-remoting-in-powershell?view=powershell-7.5

Hyper-V
https://learn.microsoft.com/en-us/powershell/module/hyper-v/?view=windowsserver2025-ps

PowerShell for Linux: Managing Hyper-V from Non-Windows Systems
https://mcsaguru.com/managing-hyper-v-from-linux-with-powershell/

Restart Network Adapters
https://learn.microsoft.com/en-us/powershell/module/netadapter/restart-netadapter?view=windowsserver2025-ps

