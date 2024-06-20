# Скрипт собирает информацию из ru052\Users\Computer и Chekcfg данные за последние 6 месяцев.

Remove-Item -Path ".\cmdb_old.csv" -Force
Rename-Item -Path ".\cmdb.csv" -NewName "cmdb_old.csv" -Force

$path = "\\ru052\Users\Computer"
$dcheckcfg = "\\ru052\app$\Chekcfg\Data"


$files = Get-ChildItem -Path $path -Filter *.csv | Where-Object { $_.LastWriteTime -ge (Get-Date).AddMonths(-6) }

foreach ($file in $files) {
  
    $data = Get-Content $file.FullName

    $lastWriteTime = $file.LastWriteTime

    $fileName = $file.Name -replace '\.csv$'

    $lastRow = $data[-1]
 
    $thirdValue = $lastRow.Split(";")[2]
    $LastLogin = $lastRow.Split(";")[3]
    $LastLogindate = $lastRow.Split(";")[0]

    $filePath = Get-ChildItem -Path $dcheckcfg -Recurse | Where-Object { $_.Name -eq $thirdValue } | Select-Object -ExpandProperty FullName
    if ($filePath) {

        $fileContent = Get-Content $filePath
   $cpu = $fileContent | Where-Object { $_ -match '^cpu=' }
        $cpuValue = if ($cpu -match 'CPU (.*)') {
        $matches[1]
        }

   $memory = $fileContent | Where-Object { $_ -match '^Memory_in' }
        $memoryValue = if ($memory -match 'Memory_in_Mb=(\d+)') {
        [math]::Round($matches[1] / 1000, 2).ToString() + " GB" 
        #$matches[1]
        }

   $hdd = $fileContent | Where-Object { $_ -match '^Total_HDD_in_Mb=' }
        $hddValue = if ($hdd -match '^Total_HDD_in_Mb=(\d+)') {
        [math]::Round($matches[1] / 1000, 2).ToString() + " GB" 
        }

   $ip = $fileContent | Where-Object { $_ -match '^IP_Addr=' }
        $ipValue = if($ip -match 'IP_Addr=(.+?) Host:') {
        $matches[1]
        }

   $recorddate = $fileContent | Where-Object { $_ -match '^Record_Date=' }
        $recorddateValue = if($recorddate -match 'Record_Date=(.*)') {
        $matches[1]
        }

   $os = $fileContent | Where-Object { $_ -match '^System=' }
        $osValue = if($os -match 'System=(.*)') {
        $matches[1]
        }  

  $monitormodel =  $fileContent | Where-Object { $_ -match '=Monitor' -and $_ -notmatch "Disabl" -and $_ -notmatch "Win_Device"}

  $hddmodel = $fileContent | Where-Object { $_ -match '=HDD' }

    Add-Content -Path ".\cmdb.csv" -Value ($LastLogin + ";" + $thirdValue + ";" + $cpuValue + ";" + $memoryValue + ";" + $hddValue + ";" + $ipValue + ";" + $osValue + ";" + $monitormodel + ";" + $hddmodel + ";" + $recorddateValue + ";" + $LastLogindate)

       } 
    }