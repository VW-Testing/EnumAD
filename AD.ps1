
$DOMAIN = "client.com"
$OUPUT_FOLDER = "C:\Users\"


$days = -60



Import-Module ActiveDirectory
Import-Module GroupPolicy


$adPoints = @(
    @{Point = "AD.1"; Description = "Bloqueio da estação após um período de inatividade"},
    @{Point = "AD.2"; Description = "Funções de auto-logon estão descativadas por GPO "},
    @{Point = "AD.3"; Description = "Mensagem de logon apresenta indicação da última tentativa de acesso "},
    @{Point = "AD.4"; Description = "Tempo máximo para login"}
    @{Point = "AD.5"; Description = "Tempo máximo para login"}
)

function AD-1{
Write-Host "Point: $($adPoints[0].Point), Description: $($adPoints[0].Description)"

}
function AD-2{
Write-Host "Point: $($adPoints[1].Point), Description: $($adPoints[1].Description)"

}
function AD-3{
Write-Host "Point: $($adPoints[2].Point), Description: $($adPoints[2].Description)"

}
function AD-4{
Write-Host "Point: $($adPoints[3].Point), Description: $($adPoints[3].Description)"

}
function AD-5{
Write-Host "Point: $($adPoints[4].Point), Description: $($adPoints[4].Description)"

}

function Get-PasswordNeverExpiresUsers {
    $users = Search-ADAccount -PasswordNeverExpires | Select-Object Name, ObjectClass
    foreach ($user in $users) {
        Write-Host "User: $($user.Name), ObjectClass: $($user.ObjectClass)"
    }
    get-aduser -filter * -properties Name, PasswordNeverExpires | where {$_.passwordNeverExpires -eq "true" } |  Select-Object DistinguishedName,Name,Enabled | Export-csv C:\Users\user_pw_never_expires.csv –NoTypeInformation
}


Get-PasswordNeverExpiresUsers


function Get-ADUsers {
    Get-ADUser -Filter * -Properties DisplayName, SamAccountName | Select-Object DisplayName, SamAccountName | Export-csv C:\Users\ad_users.csv –NoTypeInformation
    
}
Out-File -FilePath C:\PATH\TO\FOLDER\OUTPUT.txt

Get-ADUsers

#Dump AD groups
function Get-ADGroupsAndOUs {
    Get-ADGroup -Filter * | Select-Object Name| Export-csv C:\Users\StevenM-adm\Desktop\vision-enum\ad_groups.csv –NoTypeInformation
    Get-ADOrganizationalUnit -Filter * | Select-Object Name | Export-csv C:\Users\ad_ous.csv –NoTypeInformation
}


Get-ADGroupsAndOUs



## Dump GPOs
function Get-AD-GPOs {
    Write-Host "Dumping GPOs"
    Get-GPO -All | Export-csv C:\Users\ad_GPOs.csv –NoTypeInformation
}
Get-AD-GPOs


function Get-PasswordHistoryPolicy {
    $policy = Get-ADDefaultDomainPasswordPolicy
    $policy.EnforceHistoryCount
}

# Example usage:
Get-PasswordHistoryPolicy


function Get-MaximumPasswordAge {
    $policy = Get-ADDefaultDomainPasswordPolicy
    $policy.MaxPasswordAge
}

# Example usage:
Get-MaximumPasswordAge

function Get-MinimumPasswordAge {
    $policy = Get-ADDefaultDomainPasswordPolicy
    $policy.MinPasswordAge
}


Get-MinimumPasswordAge


#Password Complexity Requirements
function Get-PasswordComplexityRequirements {
    $policy = Get-ADDefaultDomainPasswordPolicy
    
    Write-Host "Password Complexity:" $policy.ComplexityEnabled
}

Get-PasswordComplexityRequirements

#Account Lockout Policy
function Get-AccountLockoutPolicy {
    $policy = Get-ADDefaultDomainPasswordPolicy
    
    Write-Host "Number of policies:" $policy.LockoutThreshold
}

Get-AccountLockoutPolicy




(get-date) - (gcim Win32_OperatingSystem).LastBootUpTime



function TempoLogin{
$path = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'

# Obtém a propriedade de tempo máximo de logon
$maxLogonTime = Get-ItemProperty -Path $path -Name 'MaxLogonTime'

# Exibe o valor da propriedade
if ($maxLogonTime.MaxLogonTime -ne $null) {
    "O limite de tempo máximo permitido para logon é: $($maxLogonTime.MaxLogonTime) segundos"
} else {
    "Não há limite de tempo máximo definido para logon."
}


}

TempoLogin



$then = (Get-Date).AddDays($days)
Get-ADComputer -Property Name,lastLogonDate -Filter {lastLogonDate -lt $then} | FT Name,lastLogonDate






Get-GPO -All

Get-ADObject -SearchBase (Get-ADRootDSE).defaultNamingContext -LDAPFilter "(objectClass=msDS-PasswordSettings)"


# Get all fine-grained password policies
$fgppList = Get-ADFineGrainedPasswordPolicy -Filter *

# Check if any policies were found
if ($fgppList.Count -eq 0) {
    Write-Host "No fine-grained password policies found."
} else {
    # Display details of each policy
    $fgppList | ForEach-Object {
        Write-Host "Policy Name: $($_.Name)"
        Write-Host "Complexity Enabled: $($_.ComplexityEnabled)"
        # Add other relevant properties here if needed
        Write-Host
    }
}


# Get the default domain password policy
$defaultPolicy = Get-ADDefaultDomainPasswordPolicy

# Check if a policy exists
if ($defaultPolicy) {
    Write-Host "Password Policy Details:"
    Write-Host "  Complexity Enabled: $($defaultPolicy.ComplexityEnabled)"
    Write-Host "  Minimum Password Length: $($defaultPolicy.MinPasswordLength)"
    Write-Host "  Max Password Age: $($defaultPolicy.MaxPasswordAge)"
    Write-Host "  Minimum Password Length: $($defaultPolicy.MinPasswordAge)"
    # Add other relevant properties here if needed
} else {
    Write-Host "No password policy found."
}
