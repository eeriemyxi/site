# Run:
#   Set-ExecutionPolicy RemoteSigned -S CurrentUser
# Or:
#   powershell -ep bypass
# Then:
#   irm myxi.qzz.io/wn/nvim.ps1 | iex

$required_programs = "git"

foreach ($cmd in $required_programs) {
  if (!(Get-Command $cmd -ErrorAction SilentlyContinue)) {
    Write-Host "$cmd not available. Install it to continue."
    exit 1
  } else {
    Write-Host "$cmd found... Good."
  }
}

$prefix = "$env:TEMP/myxi.nvim.installer"
mkdir $prefix -Force | Out-Null

$nvim_version = "latest"
$nvim_appname = "nvim-myxi"
$nvim_home = "$env:LOCALAPPDATA/$nvim_appname"
mkdir $nvim_home -Force | Out-Null

if (!(Test-Path -Path "$nvim_home/init.lua" -PathType Leaf )) {
  Invoke-WebRequest -Uri "https://myxi.qzz.io/nvim" -OutFile "$nvim_home/init.lua"
}

$arch = "win64" # Windows ARM? Who? Your mom?
# Could try: switch ($env:PROCESSOR_ARCHITECTURE) { "AMD64" { "win64" } "Arm64" { "win-arm64" } }

$download_link = "https://github.com/neovim/neovim/releases/$NVIM_VERSION/download/nvim-$arch.zip"
Write-Host $download_link

if (!(Test-Path -Path "$prefix/nvim-$arch/")) {
  Invoke-WebRequest -Uri $download_link -OutFile "$prefix/nvim.zip"
  Expand-Archive -Path "$prefix/nvim.zip" -DestinationPath "$prefix/"
}

$env:NVIM_APPNAME = $nvim_appname

& "$prefix/nvim-$arch/bin/nvim.exe"
