# MSBuild Multi Vcxproj Sample

How to organize a multi-vcxproj C++ mono repo? How about handling both static and shared libraries? This repo is a feasible sample.

We have 3 projects: `liba`, `libb`, and `hello`.

1. `liba` is a static library.
1. `libb` can be both static and shared. it directly depends on `liba`.
1. `hello` is an executable. it directly depends on `libb`, and `#include` headers from `liba`.

It has 2 exports.props in `liba\build\`, consumer should `<Import>` one of them:

1. `exports.headers.props` exports the headers only. it's for consumers linked to it indirectly.
1. `exports.static.props` exports the headers and static link to it directly.

Consumers of `liba` should not reference the `liba.vcxproj` directly.

`libb` is such a consumer, so it should:

1. Import `liba\build\exports.static.props` in its `libb.vcxproj`.
1. Import `liba\build\exports.headers.props` for consumers of `libb`.

We make `libb` a bit more complicated since it can be both static and shared.

We have 2 vcxproj files for it in `libb\build\`: `libb.vcxproj` is for shared library, and `libb_static.vcxproj` is for static library. Because they has no other difference, they imports the common `libb.props`.

MSVC asks for paired `__declspec(dllexport)` and `__declspec(dllimport)` for symbols in DLL, and neither of them should occur for symbols in static library. So we have to use macro `LIBB_EXPORTS` and `LIBB_IMPORTS` in headers as switch for different usage - build DLL, use DLL, or build/use static library. All these tricks are hidden or should be hidden for consumers of `libb`.

So it has 3 exports.props in `libb\build\`:

1. `exports.headers.props` exports the headers only. it's for consumers linked to it indirectly.
1. `exports.static.props` exports the headers and static link to it directly.
1. `exports.shared.props` exports the headers and dynamic link to it.

Now we can talk about `hello`. It can be built with either static or shared `libb`, so we have `hello.vcxproj` and `hello_shared.vcxproj`. They imports the common `hello.props` and imports `libb\build\exports.static.props` and `libb\build\exports.shared.props` respectively.

Enjoy the journey of C++ multi-project with MSBuild! It's kind of some manual work compared to CMake. It's worth to write a script to generate these exports.props, but it's not the topic here.

Additional, to show the PCH usage, we add `stdafx.h` `stdafx.cpp`, and explicitly put them in `build\` rather than source folder as the best practice.
