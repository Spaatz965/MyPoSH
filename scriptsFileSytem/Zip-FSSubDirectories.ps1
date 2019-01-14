$directories = Get-ChildItem -Directory | select name,fullname
Add-Type -assembly "system.io.compression.filesystem"

foreach ($directory in $directories) {
$arcfileName = $directory.name + ".zip"
$arcfile = Join-Path -Path $PWD -ChildPath $arcfileName
[io.compression.zipfile]::CreateFromDirectory($directory.fullname, $arcfile)
}

