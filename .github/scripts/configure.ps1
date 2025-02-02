$tools = @()
if (${env:PATH_TO_clang-tblgen}) { $tools += , "-DCLANG_TABLEGEN=${env:PATH_TO_clang-tblgen}" }
if (${env:PATH_TO_llvm-tblgen}) { $tools += , "-DLLVM_TABLEGEN=${env:PATH_TO_llvm-tblgen}" }

cmake -S llvm -B $Args[0] -C cache.cmake -G Ninja @tools `
-DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=0 -DLLVM_ENABLE_PROJECTS=clang `
-DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_EXTENSIONS=0 -DCMAKE_CXX_STANDARD_REQUIRED=1 `
-DLLVM_INCLUDE_BENCHMARKS=0 -DLLVM_ENABLE_OCAMLDOC=0 -DLLVM_ENABLE_BINDINGS=0 `
-DLLVM_INCLUDE_DOCS=0 -DLLVM_INCLUDE_TESTS=1 -DLLVM_INCLUDE_EXAMPLES=0 `
-DLLVM_INCLUDE_RUNTIMES=0 -DLLVM_INCLUDE_UTILS=1 -DLLVM_BUILD_UTILS=0 `
-DCLANG_INCLUDE_TESTS=1 -DLLVM_BUILD_TESTS=0 -DCLANG_BUILD_TESTS=0
