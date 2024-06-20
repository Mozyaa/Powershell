
# выбрать CSV-файл (SamAccountName;Title;Managerlogin;Department........ )
$csvFilePath = ".\файл CSV"

$data = Import-Csv -Path $csvFilePath -Delimiter ';'

# Перебираем строку в CSV-файле
foreach ($row in $data) {
    $samAccountName = $row.SamAccountName
    $Title = $row.Title
    $Manager = $row.Manager
    $Department = $row.Department
    $PhysicalDeliveryOfficeName = $row.Office
    $OfficePhone = $row.OfficePhone
    $Mobile = $row.Mobile
    $Company = $row.Company
    $City = $row.City



    
    # Пытаемся получить учетную запись пользователя по SamAccountName
    $user = Get-ADUser -Filter { SamAccountName -eq $samAccountName }
    
    # Если пользователь найден, обновляем атрибуты
    if ($user) {
        Set-ADUser -Identity $user -Replace @{
            Title = $Title
            Manager = (Get-ADUser -Filter { SamAccountName -eq $Manager }).DistinguishedName
            Department = $Department
            PhysicalDeliveryOfficeName = $PhysicalDeliveryOfficeName
            telephoneNumber = $OfficePhone
            Mobile = $Mobile
            Company = $Company
            l = $City
        }
        
        Write-Host "Успешно обновлены атрибуты для пользователя: $samAccountName"
    } else {
        Write-Host "Пользователь с SamAccountName '$samAccountName' не найден"
    }
}

Write-Host "Готово."