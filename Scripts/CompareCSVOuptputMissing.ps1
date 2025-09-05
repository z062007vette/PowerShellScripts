<#
    Compared two CSV and output if a line wasn't found
    This was before Beyond Compare and VS Code built in file compare
    Useful at the time, maybe less so now, but shows the process. 
    This should be improved one day. 
#>

$csvList = Import-Csv -Path 'C:\temp\Email-ID.csv' 
$idList = Get-ChildItem -Path 'C:\Temp\CompareID.csv'
$outFailure = "c:\temp\failedFinds.csv"

foreach ($line in $csvList){
    $ID = $line.'ID'

    try{
        $idList | select-string -pattern $ID
    }
    catch{
        $linkObject = new-object PSObject
        $linkObject | add-member -membertype NoteProperty -name FailedZID -Value $ID
        $linkObject | Export-csv $outFailure -notypeinformation -Append -NoClobber
        write-host "failed to find $ID"
    }
}