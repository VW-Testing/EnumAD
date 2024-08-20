

Get-Mailbox -Server "<servername>" -resultsize "Unlimited" | Get-MailboxPermission | where { ($_.AccessRights -eq "FullAccess") -and ($_.IsInherited -eq $false) -and -not ($_.User -like "NT AUTHORITY\SELF") } | ft Identity, User –AutoSize

Get-Mailbox -resultsize unlimited | Get-MailboxPermission | where {($_.user.tostring() -ne "NT AUTHORITY\SELF") -and $_.Deny -eq $false}  | Select {$_.AccessRights},Deny,InheritanceType,User,Identity,IsInherited  | Export-Csv -Path ###mailboxpermissions.csv### -NoTypeInformation



Get-MessageTrackingLog | more



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
