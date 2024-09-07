# C:\adtrust.ps1

$LocalDomain = "{{ local_domain }}"
$RemoteDomain = "{{ remote_domain }}"
$LocalDNSServer = "{{ local_dns_server }}"
$RemoteDNSServer = "{{ remote_dns_server }}"
$RemoteAdmin = "{{ remote_admin_user }}"
$RemoteAdminPassword = "{{ remote_admin_password }}"
$TrustDirection = "{{ trust_direction }}"             # Bidirectional, Inbound, Outbound
$ReplicationScope = "{{ replication_scope }}"         # Forest or Domain

$SecurePassword = ConvertTo-SecureString $RemoteAdminPassword -AsPlainText -Force
$RemoteCredentials = New-Object System.Management.Automation.PSCredential($RemoteAdmin, $SecurePassword)

# Check if DNS conditional forwarder exists using dnscmd.exe
$dnsCmdResult = & dnscmd $LocalDNSServer /ZoneInfo $RemoteDomain 2>&1
if ($dnsCmdResult -match "DNS_ERROR_ZONE_DOES_NOT_EXIST") {
    & dnscmd $LocalDNSServer /ZoneAdd $RemoteDomain /Forwarder $RemoteDNSServer 
    Write-Host "Conditional forwarder for $RemoteDomain added."
} else {
    Write-Host "Conditional forwarder for $RemoteDomain already exists. Skipping..."
}

# Create Trust between domains
try {
    $networkCredential = $RemoteCredentials.GetNetworkCredential()
    $remoteContext = New-Object "System.DirectoryServices.ActiveDirectory.DirectoryContext" ($ReplicationScope, $RemoteDomain, $networkCredential.UserName, $networkCredential.Password)
    $remoteForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetForest($remoteContext)
    Write-Host "Connected to remote forest: $($remoteForest.Name)"
    
    # Create Trust with direction 
    $localForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
    $localForest.CreateTrustRelationship($remoteForest, $TrustDirection)
    Write-Host "$TrustDirection trust created successfully."
    
} catch {
    Write-Warning "Failed: $($_.Exception.Message)"
}
