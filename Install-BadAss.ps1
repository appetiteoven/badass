


function Install-BadAss
{
    $moduleName = "BadAss"
	$global:version = "Release"
    $downloadurl = "https://raw.github.com/appetiteoven/$moduleName/$global:version/$($moduleName).psm1"
    	
    $UserModulePath = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules
	$ModulePath = $UserModulePath + "\$($moduleName)"
    		
	New-Item $ModulePath -ItemType Directory -Force | out-null
	
	$savepath = "$ModulePath\$($moduleName).psm1"
	
	Write-Host "Downloading module from `n $($downloadurl) `nto $savepath" 
	
	$client = (New-Object Net.WebClient)
	$client.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
	
	$client.DownloadFile($downloadurl, $savepath)
	
	Import-Module -Name $ModulePath -Force 
	
	Write-Host "$($moduleName) is installed and ready to use. You bad ass you." -Foreground Green
}

Install-BadAss
