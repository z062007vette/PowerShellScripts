<# 
    Out put all users from a group, strips some domain information out
#>

$userOrGroup = Read-Host -Prompt "ID or Group"

try{
    $allusers = (get-aduser -Identity $userOrGroup -Properties memberOf).memberOf
}
catch{

    try{
        $allusers = (Get-ADGroup -Identity $userOrGroup -Properties members).members
    }
    catch{
            write-host "Unable to find whatcha looking for."
        }
    }

$outPath = "c:\temp\" + $userOrGroup + ".txt"
foreach ($user in $allusers) {
    $user = $user -replace("CN=","")
    $user2 = $user -replace(",OU=",";")
    $user3 = $user2 -replace(",DC=",";")
    $user4 = $user3.split(';') 
    $user4[0] | Out-File -FilePath $outPath -append    
}