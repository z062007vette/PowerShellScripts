Clear-Host
Write-Host "Importing file."
$file = Import-Csv -Path "OneDriveSitesDEV_v2.csv"
Write-Host "Import done."
$outFile = "OneDriveSiteOwnerCheckDEV_v2.csv"
$x = 0
$personCheck = ""

Function Invoke-LoadMethod() {
    param(
       [Microsoft.SharePoint.Client.ClientObject]$Object = $(throw "Please provide a Client Object"),
       [string]$PropertyName
    ) 
       $ctx = $Object.Context
       $load = [Microsoft.SharePoint.Client.ClientContext].GetMethod("Load") 
       $type = $Object.GetType()
       $clientLoad = $load.MakeGenericMethod($type) 
    
    
       $Parameter = [System.Linq.Expressions.Expression]::Parameter(($type), $type.Name)
       $Expression = [System.Linq.Expressions.Expression]::Lambda(
                [System.Linq.Expressions.Expression]::Convert(
                    [System.Linq.Expressions.Expression]::PropertyOrField($Parameter,$PropertyName),
                    [System.Object]
                ),
                $($Parameter)
       )
       $ExpressionArray = [System.Array]::CreateInstance($Expression.GetType(), 1)
       $ExpressionArray.SetValue($Expression, 0)
       $clientLoad.Invoke($ctx,@($Object,$ExpressionArray))
}

function exportDataWStorage(){

    Write-Host $StorageAvailableGB
    Write-Host $Storage
    Write-Host $StorageFree
    Write-Host $PercentageUsed
    Write-Host $welcomeFileFound

    $linkObject = new-object PSObject
    $linkObject | add-member -membertype NoteProperty -name URL -Value $line.Url
    $linkObject | add-member -membertype NoteProperty -name OriginalOwner -Value $person.UserPrincipalName
    $linkObject | add-member -membertype NoteProperty -name CurrentSiteOwner -Value $line.Owner
    $linkObject | add-member -membertype NoteProperty -name OwnerMatch -Value $ownerMatch
    $linkObject | add-member -membertype NoteProperty -name Enabled -Value $person.enabled
    $linkObject | add-member -membertype NoteProperty -name email -Value $person.mail
    $linkObject | add-member -membertype NoteProperty -name GivenName -Value $person.GivenName
    $linkObject | add-member -membertype NoteProperty -name Surname -Value $person.Surname
    $linkObject | add-member -membertype NoteProperty -name extensionAttribute14 -Value $person.extensionAttribute14
    $linkObject | add-member -membertype NoteProperty -name lastLogonTimestamp -Value $timeStampConvert
    $linkObject | add-member -membertype NoteProperty -name HasLastMgr -Value $hasLastMRG
    $linkObject | add-member -membertype NoteProperty -name ExistingInAnotherDomain -Value $exist
    $linkObject | add-member -membertype NoteProperty -name OtherDomain -Value $server
    $linkObject | add-member -membertype NoteProperty -name OtherDomainURL -Value $ODURL
    $linkObject | add-member -membertype NoteProperty -name UserType -Value $UserType
    $linkObject | add-member -membertype NoteProperty -name 'Storage Available (GB)' -Value $StorageAvailableGB
    $linkObject | add-member -membertype NoteProperty -name 'Storage' -Value $Storage
    $linkObject | add-member -membertype NoteProperty -name 'Storage Free' -Value $StorageFree
    $linkObject | add-member -membertype NoteProperty -name 'Percentage Used' -Value $PercentageUsed
    $linkObject | add-member -membertype NoteProperty -name 'OneDrive Welcome' -Value $welcomeFileFound
    $linkObject | Export-csv $outFile -notypeinformation -Append -NoClobber
}
function exportDataWOStorage(){
    $linkObject = new-object PSObject
    $linkObject | add-member -membertype NoteProperty -name URL -Value $line.Url
    $linkObject | add-member -membertype NoteProperty -name OriginalOwner -Value $person.UserPrincipalName
    $linkObject | add-member -membertype NoteProperty -name CurrentSiteOwner -Value $line.Owner
    $linkObject | add-member -membertype NoteProperty -name OwnerMatch -Value $ownerMatch
    $linkObject | add-member -membertype NoteProperty -name Enabled -Value $person.enabled
    $linkObject | add-member -membertype NoteProperty -name email -Value $person.mail
    $linkObject | add-member -membertype NoteProperty -name GivenName -Value $person.GivenName
    $linkObject | add-member -membertype NoteProperty -name Surname -Value $person.Surname
    $linkObject | add-member -membertype NoteProperty -name extensionAttribute14 -Value $person.extensionAttribute14
    $linkObject | add-member -membertype NoteProperty -name lastLogonTimestamp -Value $timeStampConvert
    $linkObject | add-member -membertype NoteProperty -name HasLastMgr -Value $hasLastMRG
    $linkObject | add-member -membertype NoteProperty -name ExistingInAnotherDomain -Value $exist
    $linkObject | add-member -membertype NoteProperty -name OtherDomain -Value $server
    $linkObject | add-member -membertype NoteProperty -name OtherDomainURL -Value $ODURL
    $linkObject | add-member -membertype NoteProperty -name UserType -Value $UserType
    $linkObject | add-member -membertype NoteProperty -name 'Storage Available (GB)' -Value 'N/A'
    $linkObject | add-member -membertype NoteProperty -name 'Storage' -Value 'N/A'
    $linkObject | add-member -membertype NoteProperty -name 'Storage Free' -Value 'N/A'
    $linkObject | add-member -membertype NoteProperty -name 'Percentage Used' -Value 'N/A'
    $linkObject | add-member -membertype NoteProperty -name 'OneDrive Welcome' -Value $welcomeFileFound
    $linkObject | Export-csv $outFile -notypeinformation -Append -NoClobber
}
function badData(){
    #this funtion sets all values to Unknown if we can't get any user data back from AD

    $text = "Unknown"

    #Determine what user account it is
    if($line.owner -match "@company.onmicrosoft.com"){$UserType = "Azure"}
    elseif($line.owner -match "si_"){$UserType ="Service Account"}
    else{$UserType = "User"}
    $originalOwner = $ownerID + "@" + $ownerDomain

    Write-Host $StorageAvailableGB
    Write-Host $Storage
    Write-Host $StorageFree
    Write-Host $PercentageUsed
    Write-Host $welcomeFileFound

    $linkObject = new-object PSObject
    $linkObject | add-member -membertype NoteProperty -name URL -Value $line.Url
    $linkObject | add-member -membertype NoteProperty -name OriginalOwner -Value $originalOwner
    $linkObject | add-member -membertype NoteProperty -name CurrentSiteOwner -Value $line.Owner
    $linkObject | add-member -membertype NoteProperty -name OwnerMatch -Value $text
    $linkObject | add-member -membertype NoteProperty -name Enabled -Value $text
    $linkObject | add-member -membertype NoteProperty -name email -Value $text
    $linkObject | add-member -membertype NoteProperty -name GivenName -Value $text
    $linkObject | add-member -membertype NoteProperty -name Surname -Value $text
    $linkObject | add-member -membertype NoteProperty -name extensionAttribute14 -Value $text
    $linkObject | add-member -membertype NoteProperty -name lastLogonTimestamp -Value $text
    $linkObject | add-member -membertype NoteProperty -name HasLastMgr -Value $text
    $linkObject | add-member -membertype NoteProperty -name ExistingInAnotherDomain -Value $text
    $linkObject | add-member -membertype NoteProperty -name OtherDomain -Value $text
    $linkObject | add-member -membertype NoteProperty -name OtherDomainURL -Value $text
    $linkObject | add-member -membertype NoteProperty -name UserType -Value $UserType
    $linkObject | add-member -membertype NoteProperty -name 'Storage Available (GB)' -Value $StorageAvailableGB
    $linkObject | add-member -membertype NoteProperty -name 'Storage' -Value $Storage
    $linkObject | add-member -membertype NoteProperty -name 'Storage Free' -Value $StorageFree
    $linkObject | add-member -membertype NoteProperty -name 'Percentage Used' -Value $PercentageUsed
    $linkObject | add-member -membertype NoteProperty -name 'OneDrive Welcome' -Value $welcomeFileFound
    $linkObject | Export-csv $outFile -notypeinformation -Append -NoClobber
}

function getOneDriveData(){

    #this funciton will check users OneDrive data for number of files, storage used, and if the welcome to onedrive file exist
    #PROD
    <#
    $SPOuser = ""
    $SPOpassword = ConvertTo-SecureString -String "" -AsPlainText -Force
    $SPOuserCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $SPOuser,$SPOpassword
    $SPOAdminUrl = "https://company-admin.sharepoint.com"
    #>

    #DEV
    $SPOuser = ""
    $SPOpassword = ConvertTo-SecureString -String "" -AsPlainText -Force
    $SPOuserCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $SPOuser,$SPOpassword
    $SPOAdminUrl = ""

    try{
        Connect-SPOservice -url $SPOAdminUrl -credential $SPOuserCredential
        connect-msolservice -credential $SPOuserCredential
    }
    catch{
        Write-Error "unable to connect to the services needed to run. exiting" -ErrorAction Stop
    }
    $fileCounter = 0
    try{
        
        $URL = $line.Url
        Set-SPOUser -site $URL -LoginName $SPOuser -IsSiteCollectionAdmin $True
		$SPOODfBUrl = $URL
		$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SPOODfBUrl)
		$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($SPOUser,$SPOPassword)
		$ctx.RequestTimeout = 16384000
		$ctx.Credentials = $Credentials
        $ctx.ExecuteQuery()
        
        #going to try and get the storage of the site
        $ctx.Load($ctx.Site)
        Invoke-LoadMethod -Object $ctx.Site -PropertyName "Usage"
        $ctx.ExecuteQuery()
        $outputty=1099511627776-$ctx.Site.Usage.Storage
        if(!$ctx.Site.Usage.StoragePercentageUsed -eq 0)
        {
        $storageAvailable=$ctx.Site.Usage.Storage/$ctx.Site.Usage.StoragePercentageUsed /1GB 
        }
        

		$Web = $ctx.Web
		$ctx.Load($Web)
		$ctx.ExecuteQuery()

		$SPOList = $Web.Lists
		$ctx.Load($SPOList)
		$ctx.ExecuteQuery()
				  
		$SPODocLibName = "Documents"
		$List = $Web.Lists.GetByTitle($SPODocLibName)
		#$List = $Web.Lists
		$ctx.Load($List.RootFolder)
		$ctx.ExecuteQuery()

		$folders = $list.RootFolder.Folders 
		$ctx.Load($folders)
		$ctx.ExecuteQuery()

		foreach ($folder in $folders)
		{
			#write-log "Searching $($folder.name) folder"
			$files = $folder.Files
			$ctx.Load($files)
            $ctx.ExecuteQuery()
            Write-Host $folder.Name

			foreach ($file in $files)
			{
				$ctx.Load($file)
				$ctx.Load($file.ListItemAllFields)
                $ctx.ExecuteQuery()
                Write-Host $file.name
				if(!$file.name.contains(".aspx") -and !$file.name.contains("template.dotx"))
				{
                    Write-Host $file.name
                    $fileCounter++
					#write-log "Found $($file.name) at $URL"
					#Add-Content $CSVfile "$($URL),$($file.name)"					
				}
            }
            if($fileCounter -eq 1){
                Try {
                    $File = $ctx.web.GetFileByServerRelativeUrl('Documents/Welcome to OneDrive.pdf')
                    $ctx.Load($File)
                    $ctx.ExecuteQuery()
                    Write-Host $file
                    $script:welcomeFileFound = $true
                }
                Catch {
                    Write-Host $_.Exception.Message
                    $script:welcomeFileFound = $false
                }
            }
        }
        

        $script:StorageAvailableGB =  $storageAvailable
        $script:Storage = $ctx.Site.Usage.Storage/1MB
        $script:StorageFree = $outputty
        $script:PercentageUsed = [math]::round($ctx.Site.Usage.StoragePercentageUsed,2)

        Set-SPOUser -site $URL -LoginName $SPOuser -IsSiteCollectionAdmin $False
		$ctx.Dispose() 
	}
	catch
	{
		#write-log "Site does not exist - $($URL)" 
	}
	clear-variable SPOODfBUrl,URL,folders,folder,files,file,ctx,List,fileCounter

}

foreach ($line in $file){
    $siteOwnerID = $line.URL
    #$siteOwnerID = $siteOwnerID -split "",""
    $siteOwnerID = $siteOwnerID -split "",""
    $siteOwnerDomain = $siteOwnerID -split "_",3
    $ownerID = $siteOwnerDomain[1]
    $ownerDomain = $siteOwnerDomain[2]
    write-host $ownerID

    <#
    switch($ownerDomain){
        
        default{$server = "bad"}
    }#>

    switch($ownerDomain){
        "namdev"{ $server = ""; break }
        default{$server = "bad"}
    }

    if($server -eq "bad"){
        getOneDriveData
        badData
    }
    else{
        $person = Get-ADUser -Filter {SamAccountName -like $ownerID} -Properties mail,GivenName,Surname,enabled,UserPrincipalName,extensionAttribute14,lastLogonTimestamp -Server $server

        if([string]::IsNullOrEmpty($person)){
            getOneDriveData
            badData
        }
        else{
             #Checks to see if their is a match between the URL owner and the AD user
            if($person.UserPrincipalName -eq $line.Owner){ $ownerMatch = $true}
            elseif([string]::IsNullOrEmpty($person.UserPrincipalName)){$ownerMatch = "False - Blank"}
            else{$ownerMatch = $false}

            #converts the lastlongontimestamp to a date value.
            $timeStampConvert = [datetime]::FromFileTime($person.lastLogonTimestamp)

            #Checks to see if the surname has a last managers
            if($person.Surname -match "LastMgr"){$hasLastMRG = $true}
            else{$hasLastMRG = $false}

            #Determine what user account it is
            #if($line.owner -match "@company.onmicrosoft.com"){$UserType = "Azure"}
            if($line.owner -match ""){$UserType = "Azure"}
            elseif($line.owner -match "si_"){$UserType ="Service Account"}
            else{$UserType = "User"}

            #If the user doesn't have a last manager and is disabled, check other domains for a OneDrive
            if($hasLastMRG -eq $false -and $person.enabled -eq $false){
                
                <#
                #if the last manager is false, we will check all other domains for the user to try to find them.
                switch($ownerDomain){
                    default{}
                }
                $y = 0
                #loop through all possible domiains for user
                if([string]::IsNullOrEmpty($personCheck) -or $y -eq $serverList.Length){
                    foreach($server in $serverList){
                        #Write-Host $server
                        $personCheck = Get-ADUser -Filter {SamAccountName -like $ownerID} -Properties mail,GivenName,Surname,enabled,UserPrincipalName,extensionAttribute14,lastLogonTimestamp -Server $server
                        if(![string]::IsNullOrEmpty($personCheck)){
                            break
                        }
                        $y++
                        #$y
                    }
                }
            #>
            }
            

            #Check to see if a OneDrive URL exist and returns data.
            if(![string]::IsNullOrEmpty($personCheck)){
                $exist = $true
                $testDomain = $server.Replace(".","_")
                #$testURL = "https://company-my.sharepoint.com/personal/"+$ownerID+"_"+$testDomain
                $testURL = "https://company-my.sharepoint.com/personal/"+$ownerID+"_"+$testDomain
                
                try{
                    $response = Invoke-WebRequest -Method Head -Uri $testURL
                    $ODURL = $testURL
                }
                catch{
                    $ODURL = ""
                }

            }
            else{
                $exist = $false
                $server = ""
            }
            

            #This logic will check a disabled users OneDrive data
            if($person.enabled -eq $false){ 
                getOneDriveData
                exportDataWStorage
             }
             else{
                 exportDataWOStorage
             }

            $personCheck = ""
            
            $x++
            Write-Host $x
            Write-Progress -activity "Processing" -status "Scanned: $x of $($file.Count)" -percentComplete (($x / $file.Count)  * 100)
            #if($x -eq 100){
             #   break;
            #}
        }

    }

}

Write-Host "Script complete."