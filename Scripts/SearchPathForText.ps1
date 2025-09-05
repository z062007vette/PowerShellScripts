<#
    Simple method of searching for text in multiple files
    Works well if/when Windows Explorer search fails to do so
    Path is set to c:\temp, but can have user input instead
    Outputs the search results along with the file path in to a CSV
#>


#$path = Read-Host "Select path to search in"
$path = "C:\Temp\"
Set-Location -Path $path

$searchTerm = Read-Host "What are we searching for?"

$searchOutput = "c:\temp\searchResultscsv.txt"

$searchTerm = "*" + $searchTerm + "*"

$itemsInPath = Get-ChildItem -Path $path -Recurse -Filter "*.log*"
foreach($item in $itemsInPath){
    Write-Host "Checking $item"
    $lines = Get-Content $item.FullName
    
    foreach ($line in $lines){
        if($line -like $searchTerm){
            $msg = $line + ";" + $item + ";"
            write-host $msg -ForegroundColor Green
            $msg | Out-File -FilePath $searchOutput -Append
            #pause
        }
    }
    Write-Host "Done checking $item. Moving on to the next one"
}
