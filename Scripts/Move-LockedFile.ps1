function Move-LockedFile
{
    param($path, $destination)

    $path = (Resolve-Path $path).Path
    $destination = $executionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($destination)

    $MOVEFILE_DELAY_UNTIL_REBOOT = 0x00000004

    $memberDefinition = @'
    [DllImport("kernel32.dll", SetLastError=true, CharSet=CharSet.Auto)]
    public static extern bool MoveFileEx(string lpExistingFileName, string lpNewFileName,
       int dwFlags);
'@

    $type = Add-Type -Name MoveFileUtils -MemberDefinition $memberDefinition -PassThru
    $type::MoveFileEx($path, $destination, $MOVEFILE_DELAY_UNTIL_REBOOT)
}

Move-LockedFile -Path "F:\Skydrive\_cmdb\builds\12.4.0058\CMDLET Deployment\CMDBObjectModel.dll" -Destination "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\CMDB\CMDBObjectModel.dll"
