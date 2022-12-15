$archAliases = @{'amd64'='x86_64'; 'amd64_x86'='x86'; 'amd64_arm64'='arm64'}
$arch = $Args[0]
if ($archAliases.ContainsKey($arch)) { $arch = $archAliases[$arch] }
$key = "clang-format-$($env:RUNNER_OS.ToLower())-$arch"
$json = "$(Get-Content (Get-Item 'build/.cmake/api/v1/reply/target-clang-format-Release-*.json')[0].FullName)"
$exeInfo = & Get-Item -LiteralPath "build/$((ConvertFrom-JSON $json -a -d 100).artifacts[0].path)"
Set-Location $exeInfo.DirectoryName
Compress-Archive "$env:GITHUB_WORKSPACE/$key.zip" -LiteralPath $exeInfo.Name
Add-Content $env:GITHUB_OUTPUT "key=$key"

if ($env:RUNNER_OS -cne 'Linux') { return }

$ldd = "$(ldd $exeInfo.Name)"

if ($ldd -cmatch '(/\S+/libc\.so\.6)' -and "$(Invoke-Expression $Matches[1])" -cmatch 'GLIBC (\d+(?:\.\d+)+)') {
  Write-Output ('glibc version: {0}' -f $Matches[1])
} else {
  Write-Error 'ldd output does not contain libc.so.6'
}

if ($ldd -cmatch '(/\S+/libstdc\+\+\.so\.6)') {
  Write-Output ('libstdc++ version: {0}' -f (strings $Matches[1] |
  Select-String -CaseSensitive 'LIBCXX_(\d+(?:\.\d+)+)' |
  % { [System.Version]$_.Matches[0].Groups[1].Value } |
  Sort-Object -Unique -Descending)[0].ToString())
} else {
  Write-Error 'ldd output does not contain libstdc++.so.6'
}
