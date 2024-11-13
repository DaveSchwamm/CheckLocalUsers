# Define a script block to get local users on remote machines
$localuser = {
    hostname
    Get-LocalUser | Where-Object { $_.Enabled } | Select-Object Name, Enabled | Format-Table
    Write-Host "===================="
}

# Import the Active Directory module
Import-Module ActiveDirectory

# Get the list of enabled computers from the specific OU
$adComputers = Get-ADComputer -Filter {Enabled -eq $true} 

# Loop through each computer and check if it's online
$adComputers | ForEach-Object {
    $computerName = $_.Name
    
    # Test if the computer is online
    if (Test-Connection -ComputerName $computerName -Count 1 -Quiet) {
        
        # Invoke the script block on the online computer
        Invoke-Command -ErrorAction Ignore -ComputerName $computerName -ScriptBlock $localuser
    }
    else {

    }
}