$csvList = Import-Csv -Path 'C:\temp\Email-ID.csv' 
$idList = Get-ChildItem -Path 'C:\Temp\CompareID.csv'
$outFailure = "c:\temp\failedFinds.csv"

foreach ($line in $csvList){
    $ID = $line.'GMID'

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