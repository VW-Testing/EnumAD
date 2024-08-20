



$emailPoints = @(
    @{Point = "EMAIL.1"; Description = "Proteção da confidencialidade do correio eletrónico."},
    @{Point = "EMAIL.2"; Description = "SPF"},
    @{Point = "EMAIL.3"; Description = "DKIM"},
    @{Point = "EMAIL.4"; Description = "DMARC"}
    @{Point = "EMAIL.5"; Description = "Anti Spam"}
    @{Point = "EMAIL.6"; Description = "Relay"}
    @{Point = "EMAIL.7"; Description = "Politica de throttling"}
    @{Point = "EMAIL.8"; Description = "Prevenir anexos maliciosos"}
    @{Point = "EMAIL.9"; Description = "Registo de eventos"}
    @{Point = "EMAIL.10"; Description = "Restringir receção de mails com domínios locais"}
    @{Point = "EMAIL.11"; Description = "Implementação de DNSSEC"}
)



function Email-1{
    Write-Host "Point: $($emailPoints[0].Point), Description: $($emailPoints[0].Description)"
    Get-Mailbox -resultsize unlimited | Get-MailboxPermission | where {($_.user.tostring() -ne "NT AUTHORITY\SELF") -and $_.Deny -eq $false}  | Select {$_.AccessRights},Deny,InheritanceType,User,Identity,IsInherited  | Export-Csv -Path ###mailboxpermissions.csv### -NoTypeInformation

}





function Email-7{
    Write-Host "Point: $($emailPoints[6].Point), Description: $($emailPoints[6].Description)"
    Get-ThrottlingPolicy | Format-List
}


function Email-9{
    Write-Host "Point: $($emailPoints[8].Point), Description: $($emailPoints[8].Description)"
    Get-MessageTrackingLog | more
}


