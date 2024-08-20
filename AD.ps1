
$domain = "client.com"
$days = -60





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
