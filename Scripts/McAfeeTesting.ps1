cd "C:\temp\20170925FailureLogDelivery\Logs"
Write-Host "starting" -ForegroundColor Yellow
$txtfiles = Get-ChildItem -Name -Recurse -Path "C:\temp\20170925FailureLogDelivery\Logs"
$output = "C:\temp\20170925FailureLogDelivery\errorLogs\McAfeeDeletions.txt"

$testCount = 0
$msg = "MailboxName;FileName--ExtractedName;ExtensionType;ErrorDesc;"
$msg | Out-File -FilePath $output -Append

$fontErrorCount = 0
$zipErrorCount = 0
$outOfMemoryCount = 0
$unknownErrorCount = 0
$mcafeeError = 0

foreach ($file in $txtfiles){
    $matches1 = Select-String $file -pattern "Error extracting"

    foreach ($match in $matches1){

      #get just the line
      $line = $match.Line
    
      #replace characters with ;
      $line = $line -replace("Error extracting ","")
      $line = $line -replace(" with error: ",";")
      $FileName,$ErrorDesc = $line.Split(";")

      Switch -Wildcard($FileName){
        "*.xlsx"{$ExtensionType = "xlsx";break}
        "*.pptx"{$ExtensionType = "pptx";break}
        "*.pub"{$ExtensionType = "pub";break}
        "*.docx"{$ExtensionType = "docx";break}
        "*.one"{$ExtensionType = "one";break}
        "*.doc"{$ExtensionType = "doc";break}
        "*.vsdx"{$ExtensionType = "vsdx";break}
        "*.accdb"{$ExtensionType = "accdb";break}
        "*.rpmsg"{$ExtensionType = "rpmsg";break}
        "*.mso"{$ExtensionType = "mso";break}
        "*.xlsb"{$ExtensionType = "xlsb";break}
        "*.asd"{$ExtensionType = "asd";break}
        "*.xls"{$ExtensionType = "xls";break}
        "*.thmx"{$ExtensionType = "thmx";break}
        "*.oft"{$ExtensionType = "oft";break}
        "*.xlsm"{$ExtensionType = "xlsm";break}
        "*.mpp"{$ExtensionType = "mpp";break}
        "*.mdb"{$ExtensionType = "mdb";break}
        "*.obi"{$ExtensionType = "obi";break}
        "*.pst"{$ExtensionType = "pst";break}
        "*.xsn"{$ExtensionType = "xsn";break}
        "*.snp"{$ExtensionType = "snp";break}
        "*.ost"{$ExtensionType = "ost";break}
        "*.olm"{$ExtensionType = "olm";break}
        "*.dotx"{$ExtensionType = "dotx";break}
        "*.laccdb"{$ExtensionType = "laccdb";break}
        "*.vsd"{$ExtensionType = "vsd";break}
        "*.wbk"{$ExtensionType = "wbk";break}
        "*.accdr"{$ExtensionType = "accdr";break}
        "*.pptm"{$ExtensionType = "pptm";break}
        "*.ppt"{$ExtensionType = "ppt";break}
        "*.onepkg"{$ExtensionType = "onepkg";break}
        "*.xlam"{$ExtensionType = "xlam";break}
        "*.dot"{$ExtensionType = "dot";break}
        "*.pip"{$ExtensionType = "pip";break}
        "*.xltx"{$ExtensionType = "xltx";break}
        "*.ppsx"{$ExtensionType = "ppsx";break}
        "*.docm"{$ExtensionType = "docm";break}
        "*.mde"{$ExtensionType = "mde";break}
        "*.accde"{$ExtensionType = "accde";break}
        "*.ppsm"{$ExtensionType = "ppsm";break}
        "*.grv"{$ExtensionType = "grv";break}
        "*.slk"{$ExtensionType = "slk";break}
        "*.xla"{$ExtensionType = "xla";break}
        "*.potx"{$ExtensionType = "potx";break}
        "*.oab"{$ExtensionType = "oab";break}
        "*.iaf"{$ExtensionType = "iaf";break}
        "*.pps"{$ExtensionType = "pps";break}
        "*.xlw"{$ExtensionType = "xlw";break}
        "*.xlb"{$ExtensionType = "xlb";break}
        "*.crtx"{$ExtensionType = "crtx";break}
        "*.pa"{$ExtensionType = "pa";break}
        "*.xlt"{$ExtensionType = "xlt";break}
        "*.xar"{$ExtensionType = "xar";break}
        "*.dotm"{$ExtensionType = "dotm";break}
        "*.vss"{$ExtensionType = "vss";break}
        "*.ops"{$ExtensionType = "ops";break}
        "*.pot"{$ExtensionType = "pot";break}
        "*.svd"{$ExtensionType = "svd";break}
        "*.mpd"{$ExtensionType = "mpd";break}
        "*.mpt"{$ExtensionType = "mpt";break}
        "*.acl"{$ExtensionType = "acl";break}
        "*.xlm"{$ExtensionType = "xlm";break}
        "*.xltm"{$ExtensionType = "xltm";break}
        "*.xl"{$ExtensionType = "xl";break}
        "*. mdt"{$ExtensionType = " mdt";break}
        "*.accdc"{$ExtensionType = "accdc";break}
        "*.vst"{$ExtensionType = "vst";break}
        "*.ade"{$ExtensionType = "ade";break}
        "*.accdt"{$ExtensionType = "accdt";break}
        "*.mat"{$ExtensionType = "mat";break}
        "*.mdw"{$ExtensionType = "mdw";break}
        "*.vdx"{$ExtensionType = "vdx";break}
        "*.xsf"{$ExtensionType = "xsf";break}
        "*.xll"{$ExtensionType = "xll";break}
        "*.sldx"{$ExtensionType = "sldx";break}
        "*.mar"{$ExtensionType = "mar";break}
        "*.ppam"{$ExtensionType = "ppam";break}
        "*.accda"{$ExtensionType = "accda";break}
        "*.mda"{$ExtensionType = "mda";break}
        "*.ppa"{$ExtensionType = "ppa";break}
        "*.vsx"{$ExtensionType = "vsx";break}
        "*.xlc"{$ExtensionType = "xlc";break}
        "*.vtx"{$ExtensionType = "vtx";break}
        "*.prf"{$ExtensionType = "prf";break}
        "*.puz"{$ExtensionType = "puz";break}
        "*.potm"{$ExtensionType = "potm";break}
        "*.wll"{$ExtensionType = "wll";break}
        "*.accdp"{$ExtensionType = "accdp";break}
        "*.maf"{$ExtensionType = "maf";break}
        "*.sldm"{$ExtensionType = "sldm";break}
        "*.mam"{$ExtensionType = "mam";break}
        "*.accdu"{$ExtensionType = "accdu";break}
        "*.maq"{$ExtensionType = "maq";break}
        "*.cnv"{$ExtensionType = "cnv";break}
        "*.maw"{$ExtensionType = "maw";break}
        "*.msg"{$ExtensionType = "msg";break}
        "*.ppdf"{$ExtensionType = "ppdf";break}
        "*.pfile"{$ExtensionType = "pfile";break}
        "*.pjpeg"{$ExtensionType = "pjpeg";break}
        "*.7z"{$ExtensionType = "7z";break}
        "*.zip"{$ExtensionType = "zip";break}
        "*.rar"{$ExtensionType = "rar";break}
        default{write-host "error with $line" -ForegroundColor Red;break}
    }

      $msg = $file + ";" + $FileName + ";" + $ExtensionType + ";" + $ErrorDesc + ";"
      $msg | Out-File -FilePath $output -Append
      $msg

    }
    switch -Wildcard ($matches1.Line){
      "*does not support style*"{
        $fontErrorCount += 1
        #$matches1.Line
        #Write-Host "font error count is: $fontErrorCount"
      }
      "*No password supplied for encrypted zip.*"{
        $zipErrorCount += 1
        #$matches1.Line
        #Write-Host "zip error count is: $zipErrorCount"
      }
      "*System.OutOfMemoryException*"{
        $outOfMemoryCount += 1
        #$matches1.Line
        #Write-Host "OutOfMemory error count is: $outOfMemoryCount"
      }
      "*.pst with error: Unable to find the path at*"{
        $mcafeeError =+ 1
      }
      default{
        $unknownErrorCount += 1
        #Write-Host "Unknown error count is: $unknownErrorCount"
      }
    }
    #$matches1 | Out-File -FilePath $output -Append    
    $matches1

    #$testCount = $testCount +1
    if($testCount -eq 100){
		
		break
    }
        
}

Write-Host "font error count is: $fontErrorCount"
Write-Host "zip error count is: $zipErrorCount"
Write-Host "OutOfMemory error count is: $outOfMemoryCount"
Write-Host "McAfee error count is: $outOfMemoryCount"
Write-Host "Unknown error count is: $unknownErrorCount"