# Problems

## ✅ cxx\_build files not included in cmake

`cxx_build` outputs a `cc::Build` , which `cmake` can take, but only as a "guideline", 
in practice it means that the glue C++ source files generated aren't included in the build, 
so the crate fails linking due to missing symbols.

The solution is to add these source files to CMake, but this can't be done directly from the command line... 
The easiest (and taken) approach is to define a custom way to pass which folder CMake should look 
for the generated files (thankfully cxx generates them in a known location), and then have 
CMake get these sources and add them to the build.

This is done thru the `CXXBRIDGE_OUT` environment variable (at this time) 
which is specified in the crate's [`build.rs`](../crates/hello-world/build.rs) before calling cmake. 
The [`CMakeLists.txt`](../crates/hello-world/CMakeLists.txt) file of the crate, afterwards, 
will look for all C/C++ source file in the given location and add them as sources for the library to be built.

## ✅ poor C++ editor support

Setting up a C++ project is not straightforward, and many IDE/LSP/Tools have a somewhat 
opinionated way on how things should be setup and work.

The easiest and most complete way to provide proper autocompletion for each file is by 
providing the tools the [compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) 
so that the proper completion can be provided and the project can be analyzed.

This is problematic in our project since the build happens from the Rust side and in Cargo's `target` folder, 
far away from the actual source (but alongside all the generated glue from cxx), 
thus even if we tell CMake to export the compilation database it will be exported in the wrong place 
(there's no way to tell where the database should be exported, as it's hardcoded to be exported where the build is happening).

A simple workaround in the build file to tell CMake to create a symlink in the right 
location to the generated file when the desired target is built.

In practice, this leads to (a symlink to) compile\_commands.json being present 
in the CMakeLists.txt directory after a first build, which usually happens 
in the background as part of the Rust tooling trying to build the project and provide completion. 
If the file is not present simply build the project and it should appear.
