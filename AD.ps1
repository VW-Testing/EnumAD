$then = (Get-Date).AddDays(-60)
Get-ADComputer -Property Name,lastLogonDate -Filter {lastLogonDate -lt $then} | FT Name,lastLogonDate


Get-ADDefaultDomainPasswordPolicy
Get-GPOReport -All -Domain "yourdomain.com" -ReportType HTML -Path "C:\path\to\report.html"
