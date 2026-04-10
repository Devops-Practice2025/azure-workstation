#############################################
# TRY INSTALL GOOGLE CHROME (NON-BLOCKING)
#############################################

try {

    $chromeInstaller = "$env:TEMP\chrome.msi"

    Invoke-WebRequest `
    "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B00000000-0000-0000-0000-000000000000%7D/dl/chrome/install/googlechromestandaloneenterprise64.msi" `
    -OutFile $chromeInstaller `
    -ErrorAction Stop

    Start-Process msiexec.exe `
    -ArgumentList "/i $chromeInstaller /qn" `
    -Wait

    Write-Output "Chrome Installed Successfully"

}
catch {
    Write-Output "Chrome install skipped: No outbound internet"
}

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
