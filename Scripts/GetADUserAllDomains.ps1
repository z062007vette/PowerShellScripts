$file = Import-Csv -Path "D:\MyShareID.csv"
$outfile = "D:\MyShareIDADExport.csv"
$x = 0

foreach ($line in $file){
    $ID = $line.'ID'

    $person = Get-ADUser -Filter {SamAccountName -like $ID} -Properties mail,GivenName,Surname,enabled,UserPrincipalName,extensionAttribute14,lastLogonTimestamp

    if([string]::IsNullOrEmpty($person)){
        $person = Get-ADUser -Filter {SamAccountName -like $ID} -Properties mail,GivenName,Surname,enabled,UserPrincipalName,extensionAttribute14,lastLogonTimestamp -Server ""
    }

    if([string]::IsNullOrEmpty($person)){
        $person = Get-ADUser -Filter {SamAccountName -like $ID} -Properties mail,GivenName,Surname,enabled,UserPrincipalName,extensionAttribute14,lastLogonTimestamp -Server ""
    }

    if([string]::IsNullOrEmpty($person)){
        $person = Get-ADUser -Filter {SamAccountName -like $ID} -Properties mail,GivenName,Surname,enabled,UserPrincipalName,extensionAttribute14,lastLogonTimestamp -Server ""
    }

    if([string]::IsNullOrEmpty($person)){
        $person = Get-ADUser -Filter {SamAccountName -like $ID} -Properties mail,GivenName,Surname,enabled,UserPrincipalName,extensionAttribute14,lastLogonTimestamp -Server ""
    }

    if([string]::IsNullOrEmpty($person)){
        $person = Get-ADUser -Filter {SamAccountName -like $ID} -Properties mail,GivenName,Surname,enabled,UserPrincipalName,extensionAttribute14,lastLogonTimestamp -Server ""
    }

    $timeStampConvert = [datetime]::FromFileTime($person.lastLogonTimestamp)

    if([string]::IsNullOrEmpty($person)){
        $text = "Not Found"
        $linkObject = new-object PSObject
        $linkObject | add-member -membertype NoteProperty -name 'Url' -Value $line.'Url'
        $linkObject | add-member -membertype NoteProperty -name 'ID' -Value $ID
        $linkObject | add-member -membertype NoteProperty -name 'First Administrator' -Value $line.'First Administrator'
        $linkObject | add-member -membertype NoteProperty -name 'MySite Owner Name' -Value $line.'MySite Owner Name'
        $linkObject | add-member -membertype NoteProperty -name 'Second Administrator' -Value $line.'Second Administrator'
        $linkObject | add-member -membertype NoteProperty -name 'Library Name' -Value $line.'Library Name'
        $linkObject | add-member -membertype NoteProperty -name 'Number of Items' -Value $line.'Number of Items'
        $linkObject | add-member -membertype NoteProperty -name 'Welcome Doc' -Value $line.'Welcome Doc'
        $linkObject | add-member -membertype NoteProperty -name 'Size of Library (GB)' -Value $line.'Size of Library (GB)'
        $linkObject | add-member -membertype NoteProperty -name 'Last Modified Date'-Value $line.'Last Modified Date'
        $linkObject | add-member -membertype NoteProperty -name 'System'-Value $line.'System'        
        $linkObject | add-member -membertype NoteProperty -name 'Mail' -Value $text
        $linkObject | add-member -membertype NoteProperty -name 'GivenName' -Value $text
        $linkObject | add-member -membertype NoteProperty -name 'Surname' -Value $text
        $linkObject | add-member -membertype NoteProperty -name 'Enabled' -Value $text
        $linkObject | add-member -membertype NoteProperty -name 'UserPrincipalName' -Value $text
        $linkObject | add-member -membertype NoteProperty -name 'extensionAttribute14' -Value $text
        $linkObject | add-member -membertype NoteProperty -name 'lastLogonTimestamp' -Value $text
        $linkObject | Export-csv $outFile -notypeinformation -Append -NoClobber 
    }
    else{
        $linkObject = new-object PSObject
        $linkObject | add-member -membertype NoteProperty -name 'Url' -Value $line.'Url'
        $linkObject | add-member -membertype NoteProperty -name 'ID' -Value $ID
        $linkObject | add-member -membertype NoteProperty -name 'First Administrator' -Value $line.'First Administrator'
        $linkObject | add-member -membertype NoteProperty -name 'MySite Owner Name' -Value $line.'MySite Owner Name'
        $linkObject | add-member -membertype NoteProperty -name 'Second Administrator' -Value $line.'Second Administrator'
        $linkObject | add-member -membertype NoteProperty -name 'Library Name' -Value $line.'Library Name'
        $linkObject | add-member -membertype NoteProperty -name 'Number of Items' -Value $line.'Number of Items'
        $linkObject | add-member -membertype NoteProperty -name 'Welcome Doc' -Value $line.'Welcome Doc'
        $linkObject | add-member -membertype NoteProperty -name 'Size of Library (GB)' -Value $line.'Size of Library (GB)'
        $linkObject | add-member -membertype NoteProperty -name 'Last Modified Date'-Value $line.'Last Modified Date'
        $linkObject | add-member -membertype NoteProperty -name 'System'-Value $line.'System' 
        $linkObject | add-member -membertype NoteProperty -name 'Mail' -Value $person.mail
        $linkObject | add-member -membertype NoteProperty -name 'GivenName' -Value $person.GivenName
        $linkObject | add-member -membertype NoteProperty -name 'Surname' -Value $person.Surname
        $linkObject | add-member -membertype NoteProperty -name 'Enabled' -Value $person.enabled
        $linkObject | add-member -membertype NoteProperty -name 'UserPrincipalName' -Value $person.UserPrincipalName
        $linkObject | add-member -membertype NoteProperty -name 'extensionAttribute14' -Value $person.extensionAttribute14
        $linkObject | add-member -membertype NoteProperty -name 'lastLogonTimestamp' -Value $timeStampConvert
        $linkObject | Export-csv $outFile -notypeinformation -Append -NoClobber 
    }

    $x++
    Write-Progress -activity "Processing" -status "Scanned: $x of $($file.Count)" -percentComplete (($x / $file.Count)  * 100)
}