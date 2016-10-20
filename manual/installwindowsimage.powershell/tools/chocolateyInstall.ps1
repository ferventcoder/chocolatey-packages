$psFile = Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) "Install-WindowsImage.ps1"
Install-ChocolateyPowershellCommand 'installwindowsimage.powershell' $psFile  #'https://archive.msdn.microsoft.com/Project/Download/FileDownload.aspx?ProjectName=InstallWindowsImage&DownloadId=5738'
