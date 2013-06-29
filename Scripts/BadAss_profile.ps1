
#try to load the sharepoint snapin if it exists
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

if(Get-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue)
{
    write-host "Loaded Microsoft.SharePoint.PowerShell snapin" -ForegroundColor Yellow
    
    $build = get-spfarm | select buildversion
    
    write-host "`tFound a local SharePoint instance. Farm build version:`t$($build.BuildVersion)" -ForegroundColor Yellow
}

Import-Module BadAss

Set-Alias -Name gh -Value get-help

