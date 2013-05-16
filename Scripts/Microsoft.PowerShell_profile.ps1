
#try to load the sharepoint snapin if it exists
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

if(Get-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue)
{
    write-host "Loaded Microsoft.SharePoint.PowerShell snapin" -ForegroundColor Yellow
    
    $build = get-spfarm | select buildversion
    
    write-host "`tFound local SharePoint farm build version:`t$($build.BuildVersion)" -ForegroundColor Yellow
}

Import-Module BadAss

set-alias gh get-help
