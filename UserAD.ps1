# Скрипт собирает информацию обо всех пользователях в AD.

$properties = @(
    'samaccountname', 'name', 'Description', 'Title', 'Manager', 'Department', 
    'office', 'OfficePhone', 'MobilePhone', 'mail', 'company', 'city', 
    'StreetAddress', 'whenCreated', 'PasswordLastSet', 'Enabled', 'ThumbnailPhoto'
)

Get-ADUser -Filter * -Properties $properties | 
Select-Object $properties | 
Export-Csv -Path ".\alluserattrib.csv" -NoTypeInformation -Encoding utf8 -Delimiter ";"