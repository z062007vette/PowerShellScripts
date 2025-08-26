$csvList = Import-Csv -Path 'C:\temp\Email.csv' 
$outputCSVList = 'C:\temp\Email-ID.csv'
$domainForest = (Get-ADForest).domains 

foreach ($line in $csvList){
    $emailAddress = $line.EmailAddress
    foreach($domain in $domainForest){
        try{
            $ID =((Get-ADForest).domains |ForEach-Object { Get-ADUser -Server $_ -Filter {EmailAddress -eq $emailAddress} -Property CN}).CN
            $ID
            Write-Host "Found $ID for $emailAddress"
            Break
        }
        catch{
            
            Write-Host "Error finding $emailAddress"
            $ID = "Error"
        }
        
    }
    
    if($ID.Count -gt 1){
        $ID = $ID[0]
    }


    $linkObject = new-object PSObject
    $linkObject | add-member -membertype NoteProperty -name EmailOnly -Value $line.'EmailAddress'
    $linkObject | add-member -membertype NoteProperty -name ID -Value $ID
    $linkObject | Export-csv $outputCSVList -notypeinformation -Append -NoClobber

    $ID = ""
    
}