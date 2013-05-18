$VerbosePreference = "Continue"
$global:moduleName = "BadAss"

#where do i find the root path?
$env:badassSourceRootPath = "https://raw.github.com/appetiteoven/$($global:moduleName)/master/"

$env:badassScriptPath = $env:badassSourceRootPath + "Scripts/"

$env:badassPSM1Path = $env:badassSourceRootPath + "$($global:moduleName).psm1"
					
#names of scripts
$global:BadAssScripts  = @("Set-Clipboard.ps1",
                           "Set-ConsoleSize.ps1",
                           "Microsoft.PowerShell_profile.ps1")
#badass module location
$env:badassLocation 		=  "$(Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules)\BadAss\"
$env:badassScriptsLocation 	=  "$(Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules)\BadAss\Scripts\"

#where to put the profile
$psmodulepath = "$(Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell)\"

if (-not (Test-Path $env:badassLocation))
{
	New-Item ($env:badassLocation) -ItemType Directory -Force | out-null
}

function Update-BadAss
{
    process
    {
		#need to check if local version is latest than most recent commit
		#need to store last commit 
    	
	    foreach($script in $global:BadAssScripts)
	    {
		    Write-Host "Getting the latest version of $($script)" -ForegroundColor Green
		
		    #download url #"https://github.com/appetiteoven/badass/Scripts/Set-Clipboard.ps1"
		    $downloadUrl = "$($env:badassScriptPath)$($script)"
		
		    #output location for module
		    #C:\Users\sean\Documents\WindowsPowerShell\Modules\BadAssProfile
		    $destination = "$($env:badassScriptsLocation)$($script)"
		
            try   
			{
		        #download the latest version
		        $client = (New-Object Net.WebClient)
    	       	$client.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
    	        $client.DownloadFile($downloadUrl, $destination)
            }
            catch 
	        { 
	           	$_ 
	        }
	    }
		try   
		{
		    #output location for module
		    #C:\Users\sean\Documents\WindowsPowerShell\Modules\BadAssProfile
		    $destination = "$($env:badassLocation)$($global:moduleName).psm1"
			
			Write-Verbose "Downloading from $($env:badassPSM1Path) to $($destination)"
			
	        $client = (New-Object Net.WebClient)
	       	$client.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
	        $client.DownloadFile($env:badassPSM1Path, $destination)
        }
        catch 
        { 
           	$_ 
        }
	
	    #update the default profile for the user
		Write-Host "Updating user profile `n $profilepath" -ForegroundColor Green
		
	    $profilepath = "$($env:badassScriptsLocation)Microsoft.PowerShell_profile.ps1"
	    Copy-Item $profilepath -Destination $psmodulepath

       
    }
	end
	{
	 	Write-Host "Reloading badass profile" -ForegroundColor Green
		
		#reload badass
		Import-Module -Name $env:badassLocation -Force 
	}

}

#Update-BadAss -Verbose

#load functions
$global:BadAssScripts | ? {$_ -ne "Microsoft.PowerShell_profile.ps1"} | foreach { . "$env:badassScriptsLocation$_" }

Write-Host "`nWelcome to BadAss v1.0 - $(get-date) `nGood day sir. You are a badass.`n " -ForegroundColor Cyan

Set-ConsoleSize -Resize Wide

function prompt
{
    Write-Host ("badass " + $(get-location) + ">") -nonewline -foregroundcolor white
    return " "
}




