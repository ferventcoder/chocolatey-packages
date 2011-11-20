try {
  Install-ChocolateyPackage 'ilmerge' 'msi' '' 'http://www.microsoft.com/downloads/info.aspx?na=41&srcfamilyid=22914587-b4ad-4eae-87cf-b14ae6a939b0&srcdisplaylang=en&u=http%3a%2f%2fdownload.microsoft.com%2fdownload%2f1%2f3%2f4%2f1347C99E-9DFB-4252-8F6D-A3129A069F79%2fILMerge.msi'

  #------additional setup ----------------
  $processor = Get-WmiObject Win32_Processor
  $is64bit = $processor.AddressWidth -eq 64

  $progFiles = [System.Environment]::GetFolderPath('ProgramFiles')
  if ($is64bit) {$progFiles = "$progFiles (x86)"}

  $ilmergeFolder = Join-Path $progFiles "Microsoft\ILMerge"

  $ilmergeTargetFolder = (Split-Path $MyInvocation.MyCommand.Definition)
  if (![System.IO.Directory]::Exists($ilmergeTargetFolder)) {[System.IO.Directory]::CreateDirectory($ilmergeTargetFolder)}
  Write-Host "Copying the contents of `'$($ilmergeFolder)`' to `'$($ilmergeTargetFolder)`'."
  Copy-Item $ilmergeFolder $ilmergeTargetFolder –recurse -force

  Write-ChocolateySuccess 'ilmerge'
} catch {
  Write-ChocolateyFailure 'ilmerge' $($_.Exception.Message)
  throw 
}