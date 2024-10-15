$GPOName = "Disable_Windows_Defender"
$Domain = (Get-WmiObject Win32_ComputerSystem).Domain
$DomainDN = (Get-ADDomain).DistinguishedName  # Get domain distinguished name
$GPOPath = "HKLM\Software\Policies\Microsoft\Windows Defender"

New-GPO -Name $GPOName -Domain $Domain

Set-GPRegistryValue -Name $GPOName -Key $GPOPath -ValueName "DisableAntiSpyware" -Type DWORD -Value 1
Set-GPRegistryValue -Name $GPOName -Key $GPOPath -ValueName "DisableRealtimeMonitoring" -Type DWORD -Value 1
Set-GPRegistryValue -Name $GPOName -Key $GPOPath -ValueName "DisableBehaviorMonitoring" -Type DWORD -Value 1
Set-GPRegistryValue -Name $GPOName -Key $GPOPath -ValueName "DisableIntrusionPreventionSystem" -Type DWORD -Value 1
Set-GPRegistryValue -Name $GPOName -Key $GPOPath -ValueName "DisableScanningMappedNetworkDrivesForFullScan" -Type DWORD -Value 1
Set-GPRegistryValue -Name $GPOName -Key $GPOPath -ValueName "DisableBlockAtFirstSeen" -Type DWORD -Value 1
Set-GPRegistryValue -Name $GPOName -Key $GPOPath -ValueName "DisableArchiveScanning" -Type DWORD -Value 1
Set-GPRegistryValue -Name $GPOName -Key $GPOPath -ValueName "DisableScriptScanning" -Type DWORD -Value 1
Set-GPRegistryValue -Name $GPOName -Key $GPOPath -ValueName "DisableScanningNetworkFiles" -Type DWORD -Value 1
Set-GPRegistryValue -Name $GPOName -Key "$GPOPath\Real-Time Protection" -ValueName "DisableRealtimeMonitoring" -Type DWORD -Value 1

# Link GPO to the domain using distinguished name
New-GPLink -Name $GPOName -Target $DomainDN

gpupdate /force
