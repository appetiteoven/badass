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
$env:badassLocation =  "$(Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules)\BadAss\"
$env:badassScriptsLocation =  "$(Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules)\BadAss\Scripts\"


if (-not (Test-Path $env:badassLocation))
{
	New-Item ($env:badassLocation) -ItemType Directory -Force | out-null
}

#where to put the profile
$psmodulepath = "$(Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell)\"

function Update-BadAss
{
    process
    {
    		#need to check if local version is latest than most recent commit
    		#need to store last commit 
    	
	    foreach($script in $global:BadAssScripts)
	    {
		    Write-Host "Getting the latest version of $($script)" -ForegroundColor Yellow
		
		    #download url #"https://github.com/appetiteoven/spse/Scripts/Set-Clipboard.ps1"
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
		
		#update the module
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
	    $profilepath = "$($env:badassScriptsLocation)Microsoft.PowerShell_profile.ps1"
	    Copy-Item $profilepath -Destination $psmodulepath

        write-host "Updating user profile `n $profilepath" -ForegroundColor Yellow
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


#Set-Clipboard "A BADASS! Indeed..."

#write-host "Check yo clipboard son."

#iex notepad




