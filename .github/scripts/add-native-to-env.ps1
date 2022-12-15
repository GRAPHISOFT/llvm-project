foreach ($tool in @('llvm-tblgen', 'clang-tblgen')) {
  $json = "$(Get-Content (Get-Item "build-native/.cmake/api/v1/reply/target-${tool}-Release-*.json")[0].FullName)"
  $exeInfo = & Get-Item -LiteralPath "build-native/$((ConvertFrom-JSON $json -a -d 100).artifacts[0].path)"
  Add-Content $env:GITHUB_ENV "PATH_TO_$tool=$exeInfo"
}
