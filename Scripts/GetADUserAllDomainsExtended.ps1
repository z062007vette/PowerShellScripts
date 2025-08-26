$file = Import-Csv -Path "D:\System_accounts.csv"
$outfile = "D:\System_accounts_status.csv"
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

        $linkObject | add-member -membertype NoteProperty -name 'ID' -Value $ID
        $linkObject | add-member -membertype NoteProperty -name 'Name' -Value $line.'Name'
        $linkObject | add-member -membertype NoteProperty -name 'Last Login Date' -Value $line.'Last Login Date'
        $linkObject | add-member -membertype NoteProperty -name 'Role/Group' -Value $line.'Role/Group'
        $linkObject | add-member -membertype NoteProperty -name 'Mail' -Value $text
        $linkObject | add-member -membertype NoteProperty -name 'GivenName' -Value $text
        $linkObject | add-member -membertype NoteProperty -name 'Surname' -Value $text
        $linkObject | add-member -membertype NoteProperty -name 'Enabled' -Value $text
        $linkObject | add-member -membertype NoteProperty -name 'UserPrincipalName' -Value $text
        $linkObject | add-member -membertype NoteProperty -name 'extensionAttribute14' -Value $text
        $linkObject | Export-csv $outFile -notypeinformation -Append -NoClobber 
    }
    else{
        $linkObject = new-object PSObject

        $linkObject | add-member -membertype NoteProperty -name 'ID' -Value $ID
        $linkObject | add-member -membertype NoteProperty -name 'Name' -Value $line.'Name'
        $linkObject | add-member -membertype NoteProperty -name 'Last Login Date' -Value $line.'Last Login Date'
        $linkObject | add-member -membertype NoteProperty -name 'Role/Group' -Value $line.'Role/Group'
        $linkObject | add-member -membertype NoteProperty -name 'Mail' -Value $person.mail
        $linkObject | add-member -membertype NoteProperty -name 'GivenName' -Value $person.GivenName
        $linkObject | add-member -membertype NoteProperty -name 'Surname' -Value $person.Surname
        $linkObject | add-member -membertype NoteProperty -name 'Enabled' -Value $person.enabled
        $linkObject | add-member -membertype NoteProperty -name 'UserPrincipalName' -Value $person.UserPrincipalName
        $linkObject | add-member -membertype NoteProperty -name 'lastLogonTimestamp' -Value $timeStampConvert
        $linkObject | Export-csv $outFile -notypeinformation -Append -NoClobber 
    }

    $x++
    Write-Progress -activity "Processing" -status "Scanned: $x of $($file.Count)" -percentComplete (($x / $file.Count)  * 100)
}