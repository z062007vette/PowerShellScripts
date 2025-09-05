param
(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
	[string] $inputFilename
)


function Write-Log 
{ 
    [CmdletBinding()] 
    Param 
    ( 
        [Parameter(Mandatory=$true, 
                   ValueFromPipelineByPropertyName=$true)] 
        [ValidateNotNullOrEmpty()] 
        [Alias("LogContent")] 
        [string]$Message, 
 
        [Parameter(Mandatory=$false)] 
        [Alias('LogPath')] 
        [string]$Path='.\logs\OD_Inventory_ScriptLog.txt', 
         
        [Parameter(Mandatory=$false)] 
        [ValidateSet("Error","Warn","Info")] 
        [string]$Level="Info", 
         
        [Parameter(Mandatory=$false)] 
        [switch]$NoClobber 
    ) 
 
    Begin 
    { 
        # Set VerbosePreference to Continue so that verbose messages are displayed. 
        $VerbosePreference = 'Continue' 
    } 
    Process 
    { 
         
        # If the file already exists and NoClobber was specified, do not write to the log. 
        if ((Test-Path $Path) -AND $NoClobber) { 
            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name." 
            Return 
            } 
 
        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path. 
        elseif (!(Test-Path $Path)) { 
            Write-Verbose "Creating $Path." 
            $NewLogFile = New-Item $Path -Force -ItemType File 
            } 
 
        else { 
            # Nothing to see here yet. 
            } 
 
        # Format Date for our Log File 
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss" 
 
        # Write message to error, warning, or verbose pipeline and specify $LevelText 
        switch ($Level) { 
            'Error' { 
                Write-Error $Message 
                $LevelText = 'ERROR:' 
                } 
            'Warn' { 
                Write-Warning $Message 
                $LevelText = 'WARNING:' 
                } 
            'Info' { 
                Write-Verbose $Message 
                $LevelText = 'INFO:' 
                } 
            } 
         
        # Write log entry to $Path 
        "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path -Append 
    } 
    End 
    { 
    } 
}
 
 
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")  
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.UserProfiles")
 
 
$datetime = ((get-date).ToString("yyyyMMddThhmm"))
$filename = "OD_Inventory_$($datetime)"
$CSVfile = New-Item .\logs\$filename.csv -type file -Force
Add-Content $CSVfile "MyShareURL,Filename"
 
$proxyString = ""
$proxyUri = new-object System.Uri($proxyString)
[System.Net.WebRequest]::DefaultWebProxy = new-object System.Net.WebProxy ($proxyUri, $true)
[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
$cred = [System.Net.CredentialCache]::DefaultCredentials
[System.Net.WebRequest]::DefaultWebProxy.Credentials = $cred

import-module Microsoft.Online.SharePoint.Powershell

#account details for connecting to SPO
$SPOAdminUrl = "https://company-admin.sharepoint.com"
$SPOuser = ""
$SPOpassword = ConvertTo-SecureString -String "" -AsPlainText -Force
$SPOuserCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $SPOuser, $SPOpassword
Connect-SPOservice -url $SPOAdminUrl -credential $SPOuserCredential
connect-msolservice -credential $SPOuserCredential

$URLS = get-content $inputFilename
$i = 1
$count = $URLS.count
write-log "Processing $count users"
foreach ($URL in $URLS)
{
	write-log "Processing user $i of $count"
	write-log "Adding owner to $URL"
	try
	{
		Set-SPOUser -site $URL -LoginName $SPOuser -IsSiteCollectionAdmin $True
		$SPOODfBUrl = $URL
		$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SPOODfBUrl)
		$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($SPOUser,$SPOPassword)
		$ctx.RequestTimeout = 16384000
		$ctx.Credentials = $Credentials
		$ctx.ExecuteQuery()

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
			write-log "Searching $($folder.name) folder"
			$files = $folder.Files
			$ctx.Load($files)
			$ctx.ExecuteQuery()

			foreach ($file in $files)
			{
				$ctx.Load($file)
				$ctx.Load($file.ListItemAllFields)
				$ctx.ExecuteQuery()
				if(!$file.name.contains(".aspx") -and !$file.name.contains("template.dotx"))
				{
					write-log "Found $($file.name) at $URL"
					Add-Content $CSVfile "$($URL),$($file.name)"					
				}
			}
		}

		Set-SPOUser -site $URL -LoginName $SPOuser -IsSiteCollectionAdmin $False
		$ctx.Dispose() 
	}
	catch
	{
		write-log "Site does not exist - $($URL)" 
	}
	clear-variable SPOODfBUrl,URL,folders,folder,files,file,ctx,list
	$i ++
}
write-log "Report written to $($CSVfile)"