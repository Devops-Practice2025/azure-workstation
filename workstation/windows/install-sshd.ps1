Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Start-Service sshd
Set-Service -Name sshd -StartupType Automatic

New-NetFirewallRule `
-Name ssh443 `
-DisplayName "OpenSSH over 443" `
-Enabled True `
-Direction Inbound `
-Protocol TCP `
-Action Allow `
-LocalPort 443

$configPath = "C:\ProgramData\ssh\sshd_config"

(Get-Content $configPath) `
-replace '#Port 22','Port 443' `
| Set-Content $configPath

Add-Content $configPath "AllowTcpForwarding yes"
Add-Content $configPath "GatewayPorts no"

Restart-Service sshd