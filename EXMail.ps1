

Get-Mailbox -Server "<servername>" -resultsize "Unlimited" | Get-MailboxPermission | where { ($_.AccessRights -eq "FullAccess") -and ($_.IsInherited -eq $false) -and -not ($_.User -like "NT AUTHORITY\SELF") } | ft Identity, User –AutoSize

Get-Mailbox -resultsize unlimited | Get-MailboxPermission | where {($_.user.tostring() -ne "NT AUTHORITY\SELF") -and $_.Deny -eq $false}  | Select {$_.AccessRights},Deny,InheritanceType,User,Identity,IsInherited  | Export-Csv -Path ###mailboxpermissions.csv### -NoTypeInformation



Get-MessageTrackingLog | more
