$VerbosePreference = "Continue"
$global:moduleName = "BadAss"
$global:githubbranch = "release" #case senstitive!

#where do i find the root path on github?
$env:badassSourceRootPath = "https://raw.github.com/appetiteoven/$($global:moduleName)/$($global:githubbranch)/"
$env:badassScriptPath = $env:badassSourceRootPath + "Scripts/"
$env:badassPSM1Path = $env:badassSourceRootPath + "$($global:moduleName).psm1"
					
#names of scripts
#can we automate this ? get it dynamically?
#maybe look at the folder on github to decide the function names... so just adding one, adds it to the solution
$global:BadAssScripts  = @("Set-Clipboard.ps1",
                           "Set-ConsoleSize.ps1",
                           "BadAss_profile.ps1")
#badass module location
$env:badassLocation 		=  "$(Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules)\$($global:moduleName)\"
$env:badassScriptsLocation 	=  "$(Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules)\$($global:moduleName)\Scripts\"
$env:badassProfilePath 		= $env:badassLocation + "$($global:moduleName)_profile.ps1"	#BadAss_profile.ps1
$env:UserPSPath = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath "WindowsPowerShell\"

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
		$firstRun = $false
		if (-not (Test-Path $env:badassScriptsLocation ))
		{
			New-Item ($env:badassScriptsLocation ) -ItemType Directory -Force | out-null
			$firstRun = $true
		}
		#need to check if local version is latest than most recent commit
		#need to store last commit 
    	
	    foreach($script in $global:BadAssScripts)
	    {
		    Write-Verbose "Getting the latest version of $($script)" 
		
		    #download url #https://raw.github.com/appetiteoven/badass/release/Scripts/Set-Clipboard.ps1
		    $downloadUrl = "$($env:badassScriptPath)$($script)"
			
		    #output location for module
		    #C:\Users\sean\Documents\WindowsPowerShell\Modules\BadAss
		    $destination = "$($env:badassScriptsLocation)$($script)"
			
		    Write-Verbose " `tfrom url $downloadUrl `n`t to $destination"
		
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
		    #C:\Users\sean\Documents\WindowsPowerShell\Modules\BadAss
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
		Write-Verbose "Updating user profile `n $profilepath" 
		
		if(Test-Path $($PROFILE.CurrentUserCurrentHost))
		{
			$profilecontents = Get-Content $PROFILE.CurrentUserCurrentHost
			if($profilecontents -contains ". $env:badassProfilePath")
			{
				Write-Verbose "No update required. Already in profile." 
			}
			else
			{
				$profilecontents += "`n . $env:badassProfilePath `n"
				new-item -path $PROFILE.CurrentUserAllHosts -ItemType file -Force -Value $profilecontents
				Write-Verbose "Adding $($env:badassProfilePath) to end of existing profile" 
			}
			
		}
		else	#doesn't exist, create one that has a link to the badassprofile
		{
			Write-Verbose "PowerShell profile doesn't exist. Creating it and adding reference to module profile." 
			
			#add a reference to load the badass profile in master profile
			$profilecontents = ". $env:badassProfilePath"
			$profilepath = $env:UserPSPath + "Microsoft.PowerShell_profile.ps1"
			#create the file
			
			$env:UserPSPath
			new-item -Path $profilepath -ItemType file -Value $profilecontents -Force 

			#old way to update the profile was keeping a copy. this will just create it one liner and its cleaner
			#down side is hard coding the path
			#$profilepath = "$($env:badassScriptsLocation)Microsoft.PowerShell_profile.ps1"
	    	#Copy-Item $profilepath -Destination $psmodulepath
		}

    }
	end
	{
	
		if(-not $firstRun)
		{
	 		Write-Host "Reloading badass profile" -ForegroundColor Green
				
			#reload badass
			#where to put the profile
			$badasspsmodulepath = "$(Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell)\Modules\$($global:moduleName)"
			Import-Module -Name $badasspsmodulepath -Force 
		}
	}

}

#if we dont have the scripts folder, we need to update since its the first install / run
Write-Verbose "Looking if the scripts path exist... $env:badassScriptsLocation"

if (-not (Test-Path $env:badassScriptsLocation ))
{
	Write-Host "First run. Updating... $env:badassScriptsLocation"
	Update-BadAss -Verbose
}

#Update-BadAss -Verbose

#load functions
$global:BadAssScripts | ? {$_ -ne "BadAss_profile.ps1"} | foreach { . "$env:badassScriptsLocation$_" }

Write-Host "`nWelcome to BadAss v1.0 - $(get-date) `nGood day sir. You are a badass.`n " -ForegroundColor Cyan

Set-ConsoleSize -Resize Wide

function prompt
{
    Write-Host ("badass " + $(get-location) + ">") -nonewline -foregroundcolor white
    return " "
}




