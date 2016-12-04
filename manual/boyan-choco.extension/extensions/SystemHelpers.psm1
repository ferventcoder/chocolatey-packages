function IsSystem32Bit()
{
    return 
        ($Env:PROCESSOR_ARCHITECTURE -eq 'x86') -and `
        ($Env:PROCESSOR_ARCHITEW6432 -eq $null)
}

function StartAsScheduledTask() {
    param(
        [string] $name,
        [string] $executable,
        [string] $arguments
    )

    $action = New-ScheduledTaskAction -Execute $executable -Argument $arguments
    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date)

    Register-ScheduledTask -TaskName $name -Action $action -Trigger $trigger
    Start-ScheduledTask -TaskName $name
    Start-Sleep -s 1
    Unregister-ScheduledTask -TaskName $name -Confirm:$false
}