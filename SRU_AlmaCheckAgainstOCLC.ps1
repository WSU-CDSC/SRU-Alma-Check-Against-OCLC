#Set Alma institution code
$INST="01ALLIANCE_UNIV"

#Set output filename
$Path = "c:\path\to\output\file.csv"

#Set input filename
$OCLCListFile="C:\path\to\list\of\OCLC\IDs.txt"

#Ingest file of OCLC IDs
$OCLCList = Get-Content $OCLCListFile -ErrorAction SilentlyContinue

#Force use of TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Read designated .txt file and store each line sequentially in OCLC variable
foreach ($OCLC in $OCLCList) {

#Build search string, using 035 $a$z
$searchstring = "https://na01.alma.exlibrisgroup.com/view/sru/" + $INST + "?version=1.2&operation=searchRetrieve&query=alma.other_system_number_035_az=" + $OCLC

#Store result from search
[xml]$result = (New-Object System.Net.WebClient).DownloadString("$searchstring")

#Get number of records
$numRecords = $result.searchRetrieveResponse.numberOfRecords

if ($numRecords -eq 0) {

#Get MMSID
$mmsId = ""

#Get library name
$libraryNameText = ""

#Get carrier information
$carrierText = ""

#Get boundwith information
$boundwithText = ""
$localText = ""

#Report out and create output file
echo "$OCLC;$numRecords;$mmsId;$libraryNameText;$carrierText;$boundwithText;$localText" 
echo "$OCLC;$numRecords;$mmsId;$libraryNameText;$carrierText;$boundwithText;$localText" | Out-File -Append $Path

}#if ($numRecords -eq 0)

else {

#Define individual record
$indRecords = $result.searchRetrieveResponse.records.record

#Iterate through individual records
foreach ($indRecord in $indRecords) {

#Get MMSID
$mmsId = $indRecord.recordIdentifier

#Get library name, using AVA $q
$datafieldAVA = $indRecord.recordData.record.datafield | where {$_.tag -eq "AVA"}
$libraryName = $datafieldAVA.subfield | where {$_.code -eq "q"}
$libraryNameText = $libraryName."#text" -join ","

#Get carrier information, using 338 $a
$datafield338 = $indRecord.recordData.record.datafield | where {$_.tag -eq "338"}
$carrier = $datafield338.subfield | where {$_.code -eq "a"}
$carrierText = $carrier."#text"

#Get boundwith information, using 965 $a
$datafield965 = $indRecord.recordData.record.datafield | where {$_.tag -eq "965"}
$boundwith = $datafield965.subfield | where {$_.code -eq "a"}
$boundwithText = $boundwith."#text"

#Report out and create output file
echo "$OCLC;$numRecords;$mmsId;$libraryNameText;$carrierText;$boundwithText;$localText" 
echo "$OCLC;$numRecords;$mmsId;$libraryNameText;$carrierText;$boundwithText;$localText" | Out-File -Append $Path

}#foreach ($indRecord in $indRecords)

}#else ($numRecords -gt 0)

}#foreach ($OCLC in $OCLCList)

Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
