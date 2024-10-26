New-Item -Path "$env:ProgramFiles\RDP Wrapper" -ItemType Directory -Force
Add-MpPreference -ExclusionPath "$env:ProgramFiles\RDP Wrapper"
Invoke-WebRequest -Uri "https://github.com/stascorp/rdpwrap/releases/download/v1.6.2/RDPWrap-v1.6.2.zip" -OutFile "$env:ProgramFiles\RDP Wrapper\RDPWrap-v1.6.2.zip"
Expand-Archive -Path "$env:ProgramFiles\RDP Wrapper\RDPWrap-v1.6.2.zip" -DestinationPath "$env:ProgramFiles\RDP Wrapper"
Invoke-WebRequest -Uri "https://github.com/asmtron/rdpwrap/raw/master/autoupdate_v1.2.zip" -OutFile "$env:ProgramFiles\RDP Wrapper\autoupdate_v1.2.zip"
Expand-Archive -Path "$env:ProgramFiles\RDP Wrapper\autoupdate_v1.2.zip" -DestinationPath "$env:ProgramFiles\RDP Wrapper"
$process = Start-Process -FilePath "$env:ProgramFiles\RDP Wrapper\helper\autoupdate__enable_autorun_on_startup.bat"
Start-Sleep -Seconds 3  # Adjust this as needed
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Keyboard
{
    [DllImport("user32.dll", CharSet = CharSet.Auto, ExactSpelling = true)]
    public static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int extraInfo);

    public static void SendEnter()
    {
        const int KEYEVENTF_KEYUP = 0x2;
        const byte VK_RETURN = 0x0D;
        keybd_event(VK_RETURN, 0, 0, 0); // Key down
        keybd_event(VK_RETURN, 0, KEYEVENTF_KEYUP, 0); // Key up
    }
}
"@

[Keyboard]::SendEnter()

Start-Process -FilePath "$env:ProgramFiles\RDP Wrapper\autoupdate.bat" -Verb RunAs -PassThru

# Waiting for autoupdate.bat above to finish 
Start-Sleep 20