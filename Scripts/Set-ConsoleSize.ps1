


Function Set-ConsoleSize
{
	param
	(
		[Parameter(
			HelpMessage 			 		= "Type of dynamic resize. Either wide, small or custom",
			Mandatory 						= $true,
			ValueFromPipelineByPropertyName = $true
					 )]
		[ValidateSet('Wide','Small','Custom')]
        [System.String]
		$Resize,
		
		[Int]
		$CustomPercentSize
	)
	begin
	{
		Add-Type -AssemblyName System.Windows.Forms
		$screens = $([System.Windows.Forms.Screen]::AllScreens)

		#filter to the primary if multiple screens
		$screens = $screens | ? {$_.Primary -eq $true}
		
		#current resolution of primary monitor
		$width = $screens.Bounds.width
		$height = $screens.Bounds.height
	}
	process
	{
		if($Resize -eq 'Wide')
		{
			$shrinkpercent = 80 / 100

			$newwidth =  [math]::floor($width * $shrinkpercent / 7)
			$newheight =  [math]::floor($height * $shrinkpercent / 14)

			Write-Debug -Message "New width $($newwidth) `t New Height: $($newheight)"
		    
			$aff = (Get-Host).UI.RawUI
			
		    $bff = $aff.BufferSize
		    $bff.Width = $newwidth
		    $bff.Height = 9000
		    
			$aff.BufferSize = $bff
			
		    $wff = $aff.WindowSize
		    $wff.Width = $newwidth
		    $wff.Height = $newheight

		    $aff.WindowSize = $wff
		}
		elseif($Resize -eq 'Small')
		{
			$shrinkpercent = 50 / 100
			
			$newwidth =  [math]::floor($width * $shrinkpercent / 7)
			$newheight =  [math]::floor($height * $shrinkpercent / 14)

			Write-Debug -Message "New width $($newwidth) `t New Height: $($newheight)"
		    
			$aff = (Get-Host).UI.RawUI
			
		    $wff = $aff.WindowSize
		    $wff.Width = $newwidth
		    $wff.Height = $newheight
			
			$aff.WindowSize = $wff
			
		    $bff = $aff.BufferSize
		    $bff.Width = $newwidth
		    $bff.Height = 9000
			
			$aff.BufferSize = $bff
		}
		else	#custom size
		{
			if(!$CustomPercentSize)
			{
				throw("You must provide a CustomPercentSize")
			}
			
			$shrinkpercent = $CustomPercentSize / 100
			
			$newwidth =  [math]::floor($width * $shrinkpercent / 7)
			$newheight =  [math]::floor($height * $shrinkpercent / 14)

			Write-Debug -Message "New width $($newwidth) `t New Height: $($newheight)"
		    
			$aff = (Get-Host).UI.RawUI
			
		    $wff = $aff.WindowSize
		    $wff.Width = $newwidth
		    $wff.Height = $newheight
			
			$aff.WindowSize = $wff
			
		    $bff = $aff.BufferSize
		    $bff.Width = $newwidth
		    $bff.Height = 9000
			
			$aff.BufferSize = $bff
		}
	}
}


