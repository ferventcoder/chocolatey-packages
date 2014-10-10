try {
  $sqlPassword = 'chocolatey'

  Write-Host "Installing SQLServer Express with a default admin password of `'$sqlPassword`' - You will want to change this later. This install takes about 30 minutes or so. There may be a compatibility warning pop up, click to continue. After you have clicked that, you can go do something else for awhile."
  Start-Sleep 10

  chocolatey install SQLExpressTools -source webpi -installArguments "/SQLPassword:$sqlPassword"

  Write-ChocolateySuccess 'SqlServerExpress'
} catch {
  Write-ChocolateyFailure 'SqlServerExpress' "$($_.Exception.Message)"
  throw
}
