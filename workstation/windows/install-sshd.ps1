# #############################################
# # TRY INSTALL GOOGLE CHROME (NON-BLOCKING)
# #############################################

# try {
#     # Force TLS 1.2 (REQUIRED for Google download)
#     [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#     $chromeInstaller = Join-Path $env:TEMP "chrome.msi"

#     Write-Output "Downloading Chrome MSI..."

#     Invoke-WebRequest `
#         -Uri "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi" `
#         -OutFile $chromeInstaller `
#         -UseBasicParsing `
#         -ErrorAction Stop

#     Write-Output "Installing Chrome..."

#     $arguments = "/i `"$chromeInstaller`" /qn /norestart"

#     $process = Start-Process `
#         -FilePath "msiexec.exe" `
#         -ArgumentList $arguments `
#         -Wait `
#         -PassThru `
#         -ErrorAction Stop

#     if ($process.ExitCode -eq 0) {
#         Write-Output "✅ Chrome installed successfully"
#     }
#     else {
#         Write-Output "⚠️ Chrome installer exited with code $($process.ExitCode)"
#     }
# }
# catch {
#     Write-Output "❌ Chrome installation failed:"
#     Write-Output $_.Exception.Message
# }


#############################################
# INSTALL OPENSSH SERVER (MANDATORY)
#############################################

Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Start-Service sshd
Set-Service -Name sshd -StartupType Automatic

#############################################
# MOVE SSH TO 443
#############################################

New-NetFirewallRule `
-Name ssh443 `
-DisplayName "OpenSSH over 443" `
-Enabled True `
-Direction Inbound `
-Protocol TCP `
-Action Allow `
-LocalPort 443 `
-ErrorAction SilentlyContinue

$configPath = "C:\ProgramData\ssh\sshd_config"

(Get-Content $configPath) `
-replace '#Port 22','Port 443' `
| Set-Content $configPath

Add-Content $configPath "AllowTcpForwarding yes"
Add-Content $configPath "GatewayPorts no"

Restart-Service sshd

exit 0
