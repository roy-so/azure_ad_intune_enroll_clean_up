# Define the path variable
$TaskPath = "\Microsoft\Windows\EnterpriseMgmt\"

# Get all tasks recursively under the provided task path
$StrPath = "$($TaskPath)*"
$tasks = Get-ScheduledTask | Where-Object{$_.TaskPath -like $StrPath}

# Loop through each task
foreach ($task in $tasks) {
    # Get the name of each task and convert it to string
    $subTaskPath = $task.TaskPath.ToString()
    
    # Extracting the value using -split operator
    $value = ($subTaskPath -split "\")[-2]
    Write-Host "Value: $value"

    if ($value -match '........\-....\-....\-....\-............') {
        Write-Host "String matches the pattern. Value is $value"
            
        # Unregister the scheduled task
        Unregister-ScheduledTask -TaskPath $subTaskPath -Confirm:$false

        # Check if the task name exists in the registry
        
        $registryKeyPath1 = "HKLM:\SOFTWARE\Microsoft\Enrollments\$value"
        if (Test-Path "$registryKeyPath1") {

            # Delete the registry key
            Write-Host "Deleting the key: $registryKeyPath1"
            Remove-Item -Path "$registryKeyPath1\" -Recurse

        $registryKeyPath2 = "HKLM:\SOFTWARE\Microsoft\EnterpriseResourceManager\Tracked\$value"
        if (Test-Path $registryKeyPath2) {
            # Delete the registry key
            Write-Host "Deleting the key: $registryKeyPath2"
            Remove-Item -Path $registryKeyPath2 -Recurse    
        }

        $registryKeyPath3 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\AdmxInstalled\$value"

        if (Test-Path $registryKeyPath3) {
            # Delete the registry key
            Write-Host "Deleting the key: $registryKeyPath3"
            Remove-Item -Path $registryKeyPath3 -Recurse    
        }

        $registryKeyPath4 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers\$value"

        if (Test-Path $registryKeyPath4) {
            # Delete the registry key
            Write-Host "Deleting the key: $registryKeyPath4"
            Remove-Item -Path $registryKeyPath4 -Recurse    
        }

        $registryKeyPath5 = "HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Accounts\$value"

        if (Test-Path $registryKeyPath5) {
            # Delete the registry key
            Write-Host "Deleting the key: $registryKeyPath5"
            Remove-Item -Path $registryKeyPath5 -Recurse    
        }

        $registryKeyPath6 = "HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Logger\$value"

        if (Test-Path $registryKeyPath6) {
            # Delete the registry key 
            Write-Host "Deleting the key: $registryKeyPath6"
            Remove-Item -Path $registryKeyPath6 -Recurse    
        }

        Write-Host "Above Keys Deleted"

        #Manually Join.
        Write-Host "Join Azure AD in Hybrid"
        Invoke-Expression -Command 'C:\Windows\system32\deviceenroller.exe /c /AutoEnrollMDM'

        } else {
            Write-Host "String does not match the pattern. i.e. Not enrollement value here."
        }
    }    
}


