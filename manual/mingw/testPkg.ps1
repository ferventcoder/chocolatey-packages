choco pack mingw.nuspec

choco install -y -r mingw -source .
if ($LASTEXITCODE -ne 0) { throw ("Terminating. Last command failed with exit code $LASTEXITCODE") }
choco uninstall -y -r mingw
if ($LASTEXITCODE -ne 0) { throw ("Terminating. Last command failed with exit code $LASTEXITCODE") }

foreach ($thread in 'win32','posix') {
  # 64-bit
  foreach ($exception in 'sjlj','seh') {
    choco install -y -r mingw -source . -params "/exception:${exception} /threads:${thread}"
    if ($LASTEXITCODE -ne 0) { throw ("Terminating. Last command failed with exit code $LASTEXITCODE") }
    choco uninstall -y -r mingw
    if ($LASTEXITCODE -ne 0) { throw ("Terminating. Last command failed with exit code $LASTEXITCODE") }
  }

  # 32-bit
  foreach ($exception in 'sjlj','dwarf') {
    choco install -y -r mingw -source . -params "/exception:${exception} /threads:${thread}" -x86
    if ($LASTEXITCODE -ne 0) { throw ("Terminating. Last command failed with exit code $LASTEXITCODE") }
    choco uninstall -y -r mingw
    if ($LASTEXITCODE -ne 0) { throw ("Terminating. Last command failed with exit code $LASTEXITCODE") }
  }
}

echo "Package built successfully"
