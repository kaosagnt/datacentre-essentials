# Known Issues with Microsoft Windows Server 2025

## Unreachable Windows Server domain controllers

Issue: Windows Server 2025 domain controllers (DCs) might become inaccessible after a restart, causing apps and services to fail or remain unreachable.

Issue: Windows Server 2025 domain controllers (such as servers hosting the Active Directory domain controller role) might not manage network traffic correctly following a restart.

Workaround: Addressed by manually restarting the network adapter on impacted servers using various methods, including the following PowerShell command:

	Restart-NetAdapter *.

Note: Administrators must restart the network adapter after every reboot because this known issue triggers whenever the domain controller is restarted.

Fix: Issue addressed in the [KB5060842](https://support.microsoft.com/en-au/topic/june-10-2025-kb5060842-os-build-26100-4349-47ff300b-2a04-440c-9476-2860d04fce8d#id0enbd=catalog) Windows security update released during the [June 2025 Patch Tuesday](https://www.bleepingcomputer.com/news/microsoft/microsoft-june-2025-patch-tuesday-fixes-exploited-zero-day-66-flaws/).

## Reference list

Abrams, L 2025, *Microsoft June 2025 Patch Tuesday fixes exploited zero-day, 66 flaws*, BleepingComputer, viewed 13 June 2025, <<https://www.bleepingcomputer.com/news/microsoft/microsoft-june-2025-patch-tuesday-fixes-exploited-zero-day-66-flaws/>>.

*June 10, 2025—KB5060842 (OS Build 26100.4349) - Microsoft Support* 2025, Microsoft.com, viewed 13 June 2025, <<https://support.microsoft.com/en-au/topic/june-10-2025-kb5060842-os-build-26100-4349-47ff300b-2a04-440c-9476-2860d04fce8d>>.

Sergiu Gatlan 2025, *Microsoft fixes unreachable Windows Server domain controllers*, BleepingComputer, viewed 13 June 2025, <<https://www.bleepingcomputer.com/news/microsoft/microsoft-fixes-unreachable-windows-server-domain-controllers/>>.


