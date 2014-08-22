function Get-Rubies {
  $paths = @{
    $true=$ENV:PATH;
    $false=[Environment]::GetEnvironmentVariable("Path", "Machine")
  }
  
  return $paths[$ENV:PATH -like "*ruby*"] -split ";" `
    | ?{ $_ -like "*ruby*bin" } `
    | %{ Split-Path $_ }
}

function Remove-RubyDevkitLegacy($ruby) {  
  $devkit = Join-Path $ruby "devkit"
  $bin = Join-Path $ruby "bin"
  
  @("gcc.bat", "make.bat", "sh.bat") `
    | %{ Join-Path $bin $_ } `
    | ?{ Test-Path $_ } `
    | %{ Remove-Item $_ -Force }

  if(Test-Path $devkit) {
    Remove-Item $devkit -Recurse -Force
  }
}

function Remove-RubyDevkit($devkit) {
  if(-not (Test-Path $devkit)) {
    return
  }
  
  Remove-Item $devkit -Recurse -Force
}

function Backup-RubyDevkitCustomizations($devkit, $temp) {
  @("config.yml", "etc", "home") `
    | %{ Join-Path $devkit $_ } `
    | ?{ Test-Path $_ } `
    | %{ Copy-Item $_ $temp -Recurse -Force }
}

function Restore-RubyDevkitCustomizations($devkit, $temp) {
  @("config.yml", "etc", "home") `
    | %{ Join-Path $temp $_ } `
    | ?{ Test-Path $_ } `
    | %{ Copy-Item $_ $devkit -Recurse -Force }
}

function Extract-RubyDevkit($installer, $devkit) {
  #& 7za x -o"$devkit" -y "$installer"
  Start-Process "7za" -ArgumentList "x -o`"$devkit`" -y `"$installer`"" -Wait
}

function Install-RubyDevkit($devkit) {      
  Push-Location $devkit
  & ruby dk.rb init
  & ruby dk.rb install --force
  Pop-Location
}
