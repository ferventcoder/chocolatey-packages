param (
 [string]$symlinktype,
 [string]$link,
 [string]$target
)

$scriptpath = $MyInvocation.MyCommand.Path
$ScriptDir = Split-Path $scriptpath

$senable = Join-Path "$ScriptDir" senable.exe
$ln = Join-Path "$ScriptDir" ln.exe

pushd "$ScriptDir"
& cmd /c "$senable" install
popd
& cmd /c "$ln" -s "$target" "$link"