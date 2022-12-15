$h = @{}
if ($env:RUNNER_OS -ceq 'Windows') {
  $c = '/DWIN32 /D_WINDOWS /utf-8 /permissive- /volatile:iso /Zc:preprocessor'
  $h['CMAKE_C_FLAGS'] = $c
  $h['CMAKE_CXX_FLAGS'] = "$c /Zc:__cplusplus /Zc:externConstexpr /Zc:throwingNew /EHsc"
  $c = '/MD /O2 /DNDEBUG /GL'
  $h['CMAKE_C_FLAGS_RELEASE'] = $c
  $h['CMAKE_CXX_FLAGS_RELEASE'] = $c
  $h['CMAKE_EXE_LINKER_FLAGS_RELEASE'] = '/INCREMENTAL:NO /OPT:ICF /OPT:REF /LTCG'
} elseif ($env:RUNNER_OS -ceq 'Linux') {
  $h['CMAKE_CXX_FLAGS'] = '-fexceptions'
  $c = '-DNDEBUG -O3 -flto=auto'
  $h['CMAKE_C_FLAGS_RELEASE'] = $c
  $h['CMAKE_CXX_FLAGS_RELEASE'] = $c
  $h['CMAKE_EXE_LINKER_FLAGS_RELEASE'] = '-s'
} elseif ($env:RUNNER_OS -ceq 'macOS') {
  $h['CMAKE_OSX_ARCHITECTURES'] = $Args[0]
  # $h['CMAKE_XCODE_ATTRIBUTE_MACOSX_DEPLOYMENT_TARGET'] = '???'
  $h['CMAKE_CXX_FLAGS'] = '-fexceptions'
  $c = '-DNDEBUG -O3 -flto=thin'
  $h['CMAKE_C_FLAGS_RELEASE'] = $c
  $h['CMAKE_CXX_FLAGS_RELEASE'] = $c
}
$h.GetEnumerator() | % { 'set([[{0}]] [[{1}]] CACHE STRING "")' -f $_.Key, $_.Value } >cache.cmake

Write-Output 'Contents of "cache.cmake":'
Get-Content cache.cmake
