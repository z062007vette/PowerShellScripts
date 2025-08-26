Write-Host "starting" -ForegroundColor Yellow
$outputFailureListCSV = Import-Csv -Path "Path\failures.csv"
$errorCodeArray = @("","")

$x = 0
foreach($line in $outputFailureListCSV.ErrorCode){
    Write-Host "line is $line at $x"
    foreach ($code in $errorCodeArray){
        if($code -match $line){
            Write-Host "try to count?"
        }
        else{
            Write-Host "try to add?????"
            $errorCodeArray += ,@($line, 1)
        }
    }
    #$errorMatch = $errorCodeArray | ?{$errorCodeArray -match $outputFailureListCSV.ErrorCode}

    #$errorMatch

    $x += 1
}

$errorCodeArray