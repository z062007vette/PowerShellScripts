Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    Filter = 'SpreadSheet (*.csv)|*.csv'
}
$null = $FileBrowser.ShowDialog()

$allADForests = (Get-ADForest).domains
$allADForests = $allADForests + ""

$filePath = $FileBrowser.FileName
<#
$rawCSV = Get-Content -Path $filePath | Select-Object -skip 6
$orgPath = Split-Path -Parent $FileBrowser.FileName
$orgFileName = [io.path]::GetFileNameWithoutExtension($filePath)

$correctedCSVOutPath = $orgPath + "\" + $orgFileName + "-corrected.csv"
$rawCSV | Out-File -FilePath $correctedCSVOutPath -Encoding utf8

$reImportCSV = Get-Content -Path $correctedCSVOutPath
#>

$allIDs = Get-Content -Path $filePath

$orgPath = Split-Path -Parent $FileBrowser.FileName
$orgFileName = [io.path]::GetFileNameWithoutExtension($filePath)
$correctedCSVOutPath = $orgPath + "\" + $orgFileName + "-emails.csv"

$i = 1
$totalitems = $allIDs.count
$server = ""
foreach ($line in $allIDs) {
    #$line
    Write-Progress -Activity "Writting users to outputfile" -Status "Progress: $i of $totalItems" -PercentComplete (($i / $totalItems)*100)
    
    try{
        $userEmail = (Get-ADUser -Identity $line -Properties mail -Server "nam.corp.gm.com").mail
        $server = "nam\"
    }
    catch{
        try{
            foreach($forest in $allADForests){
                try{
                    $userEmail = (Get-ADUser -Identity $line -Properties mail -Server $forest).mail
                    $server =  ($forest.split("."))[0] + "\"
                    break;
                }
                catch{
                    Write-Host "No results found in $forest. Continuing search."
                }  
            }
        }
        catch{
            Write-Host "Failed to find an email for $line"
        }
    }
    
    $output = $server + $line + "," + $userEmail

    $output | Out-File -FilePath $correctedCSVOutPath -Append -Encoding utf8
    $i++

}

#Get-ADUser -Identity $user -Properties 