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
$env:badassProfilePath 		= $env:badassScriptsLocation + "$($global:moduleName)_profile.ps1"	#BadAss_profile.ps1
$env:UserProfilePath 		= Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath "WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

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
		Write-Verbose "Updating user profile `n $env:UserProfilePath " 
	
			
		if(Test-Path $env:UserProfilePath )
		{
			$profilecontents = Get-Content $env:UserProfilePath 
			$found = $false
			
			foreach($line in $profilecontents)
			{
				if($line -like "* . $($env:badassProfilePath)*")
				{
					Write-Verbose "No update required. Already in profile." 
					$found = $true
				}
			}
			if(-not $found)
			{
				Add-Content -LiteralPath $env:UserProfilePath -Value "`n . $env:badassProfilePath `n "
			}
		}
		else	#doesn't exist, create one that has a link to the badassprofile
		{
			Write-Verbose "PowerShell profile doesn't exist. Creating it and adding reference to module profile." 
			
			#add a reference to load the badass profile in master profile
			$profilecontents = "`n . $env:badassProfilePath `n "
			
			#create the default user file
			new-item -Path $env:UserProfilePath  -ItemType file -Value $profilecontents -Force  | Out-Null

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

function Remove-BadAss
{
  process
    {
		#delete the files and folders
	    Remove-Item -LiteralPath $env:badassLocation -Recurse
		
		if(Test-Path $env:UserProfilePath )
		{
			$profilecontents = Get-Content $env:UserProfilePath 
			
			$newprofile = ""
			foreach($line in $profilecontents)
			{
				if($line -notlike "* . $($env:badassProfilePath)*")
				{
					$newprofile += $line + "`n "
				}
			}
			new-item -path  $env:UserProfilePath -ItemType file -Force -Value $newprofile | Out-Null
			Write-Verbose "Removing $($env:badassProfilePath) from existing profile" 
			
		}
		else	#doesn't exist, create one that has a link to the badassprofile
		{
			Write-Verbose "Default user PowerShell profile doesn't exist." 
		}

    }
	
}

#if we dont have the scripts folder, we need to update since its the first install / run
Write-Verbose "Checking if the scripts folder exist... $env:badassScriptsLocation"

if (-not (Test-Path $env:badassScriptsLocation ))
{
	Write-Verbose "First run. Updating... $env:badassScriptsLocation"
	Update-BadAss
}

#load functions
$global:BadAssScripts | ? {$_ -ne "BadAss_profile.ps1"} | foreach { . "$env:badassScriptsLocation$_" }

Write-Host "`nWelcome to BadAss v1.0 - $(get-date) `nGood day sir. You are a badass.`n " -ForegroundColor Cyan

Set-ConsoleSize -Resize Wide

function prompt
{
    Write-Host ("badass " + $(get-location) + ">") -nonewline -foregroundcolor white
    return " "
}




