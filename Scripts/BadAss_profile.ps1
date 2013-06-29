
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

$LastWriteTime = $(Get-ChildItem -Path $env:badassLocation -Recurse | select LastWriteTime -First 1 | sort LastWriteTime -Descending).LastWriteTime

Write-Host "`nwelcome to badass. good day sir. `n`n$(get-date) is the current time`n$($LastWriteTime) last update for badass. `n " -ForegroundColor Cyan

#region host customizations

	if ($Host.Name -like '*Windows PowerShell ISE Host*') 
	{
		function prompt
		{
		    Write-Host ("badass " + $(get-location) + ">") -NoNewline
		    return " "
		}
	}

	if($Host.Name -like '*PowerGUIScriptEditorHost*')
	{
		function prompt
		{
		    Write-Host ("badass " + $(get-location) + ">") -nonewline
		    return " "
		}
	}

	if ($Host.Name -like '*ConsoleHost*')
	{
		Set-ConsoleSize -Resize Wide
		
		function prompt
		{
		    Write-Host ("badass " + $(get-location) + ">") -nonewline -foregroundcolor white
		    return " "
		}
	}	
		
#endregion 