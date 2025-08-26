#try to connec to Azure first. Don't prompt again if already logged in
if($x -ne 1){
    Connect-AzureAD
    $x = 1
}

#ask if it's a group or user pull
$userOrGroupPull = Read-Host "User or group pull"
$toRun = ""
$LocalAD = ""
$AzureADGroups = ""
$allusers = ""
#run code based on input

switch($userOrGroupPull){
    "user"{$toRun = "user";break;}
    "group"{$toRun = "group";break;}
    default{$toRun = "error";break;}
}

#user context
if($toRun -eq "user"){
    $email = Read-Host "Enter email address"
    $userDetails = Get-AzureADUser -searchstring $email
    $FullUPN = $userDetails.UserPrincipalName
    $OID = $userDetails.ObjectID
    $AzureADGroups = (Get-AzureADUserMembership -ObjectId $OID).DisplayName | Sort-Object

    <#
    $UPNEdit = $FullUPN.split('@')
    $UPN = $UPNEdit[0]
    $server = $UPNEdit[1]
    #$allusers = (get-aduser -Identity $UPN -Properties memberOf -server $server).memberOf | Sort-Object
    $allusers = (get-aduser $UPN -Properties memberOf -server $server).MemberOf  | Get-ADGroup -Server $server | Select-Object -ExpandProperty name | Sort-Object
    $LocalAD = $allusers

    Compare-Object -ReferenceObject $AzureADGroups -DifferenceObject $LocalAD
    #>

}
#group context
elseif($toRun -eq "group"){

}
#error context
elseif($toRun -eq "error"){
    write-host "Run again and put in user or group. Spelling matters!"

}
#really bad error context
else{
    Write-Host "Things really broke if we made"
}

