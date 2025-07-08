## Windows Server SID Reset

Before you can deploy a Windows image to new PCs, you have to first generalize the image. Generalizing the image removes computer-specific information such as installed drivers and the computer security identifier (SID). 

The generalize configuration pass of Windows Setup is used to create a Windows reference image that can be used throughout an organization. Settings in the generalize configuration pass enable you to automate the behavior for all deployments of this reference image


C:\Windows\system32\Sysprep\sysprep.exe

	sysprep /generalize /oobe /shutdown


## Reference list

windows-driver-content 2021a, *generalize*, Microsoft.com, viewed 8 July 2025, <<https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/generalize?view=windows-11>>.

― n.d., *Sysprep (Generalize) a Windows installation*, learn.microsoft.com, <<https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/generalize?view=windows-11>>.

― 2021b, *Sysprep Command-Line Options*, Microsoft.com, viewed 8 July 2025, <<https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/sysprep-command-line-options?view=windows-11#audit>>.
