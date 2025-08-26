#This is going to clear up temp directories. 
Write-Host "Clearing env temp directories"

Write-Host "clearing $env:TEMP"
try{
    Remove-Item -Verbose -Recurse $env:TEMP -ErrorAction SilentlyContinue
}
catch
{
    Write-Host "File cannot be deleted because it is open by another process" -ForegroundColor yellow
}

Write-Host "clearing $env:TMP"
try{
    Remove-Item -Verbose -Recurse $env:TMP -ErrorAction SilentlyContinue
}
catch
{
    Write-Host "File cannot be deleted because it is open by another process" -ForegroundColor yellow
}
Write-Host "Emptying Recycle bin"
try{
    Clear-RecycleBin -Force
}
catch{
    Write-Host "Unable to empty the recycle bin"
}

Write-Host "done"