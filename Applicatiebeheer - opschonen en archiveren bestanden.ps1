<#

.SYNOPSIS

Ruimt files op door ze te archiveren op maand/jaar en dan te deleten.

.DESCRIPTION 

#>

#Scherm leegmaken. In plaats van het oude commando CLS oftewel CLearScreen de juiste CMDlet gebruikt.
Clear-Host

#Directories definieren:
# $Gpath = "Z:\dir\subdir\subdir"

# Periode vast stellen waar tot gearchiveerd wordt.
$ArchiveToDate = ((Get-Date).AddMonths(-5))
# Oudste bestand zoeken.
$OudsteBestand = Get-ChildItem -Path $GPath -Filter *.pdf | Sort-Object -Property LastWriteTime | Select-Object -first 1
$OudsteVar = $OudsteBestand.LastWriteTime

While ( ( [string]$ArchiveToDate.year+[string]$ArchiveToDate.month ) -ne ( [string]$OudsteVar.year+[string]$OudsteVar.month ) ) 
   {
    # Naam archief bestand bepalen wat er bij hoort. 
    $ArchiveDateZipFile = "MCSFacturen_"+([string]($OudsteVar.year))+"_"+([string]($OudsteVar.month))+".zip"

    # Bestandsnaam als volledig UNC pad
    $ArchiveDateZipFilePath =  $GPath+ "\"+$ArchiveDateZipFile
    $ArchiveDateZipFilePath

    # Overbodige check of het archief bestaat of moet worden aangemaakt maar geeft mij een kans om test-path uit te voeren. 
    if ([String](Test-Path -Path $ArchiveDateZipFilePath) -eq "False")
       {
        $TeZippenBestanden = Get-ChildItem -Path $GPath -Filter *.pdf | where-object  {(get-date($_.LastWriteTime).year) -eq (get-date($OudsteVar).year)} | where-object { (get-date($_.LastWriteTime).month) -eq (get-date($OudsteVar).month) }
        $TeZippenBestanden | Compress-Archive -DestinationPath $ArchiveDateZipFilePath 
       }
    else
       {
        Write-Host "True -update"
        $TeZippenBestanden = Get-ChildItem -Path $ProdPath -Filter verwer*.csv | where-object  {(get-date($_.LastWriteTime).year) -eq (get-date($OudsteVar).year)} | where-object { (get-date($_.LastWriteTime).month) -eq (get-date($OudsteVar).month) } 
        Compress-Archive -update -DestinationPath $ArchiveDateZipFilePath 
       }

    # Check archive
    $Archive = [System.IO.Compression.ZipFile]::Open("$ArchiveDateZipFilePath",[System.IO.Compression.ZipArchiveMode]::Read)
    if ( ($Archive.entries).count -eq $TeZippenBestanden.count) 
       {
        # Opschonen bestanden
        $TeZippenBestanden | Remove-Item -Recurse  
        ($Archive.entries).count 
        $TeZippenBestanden.count
        $Archive.dispose()
       }  
    else
       {
        $error = Read-Host -Prompt 'error'
       }         

    # Ophogen 
    $OudsteVar = get-date($OudsteVar).AddMonths(1)
    $OudsteVar
   }

   
