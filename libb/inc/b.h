#pragma once

#if defined(LIBB_EXPORTS)
#define LIBB_API __declspec(dllexport)
#elif defined(LIBB_IMPORTS)
#define LIBB_API __declspec(dllimport)
#else
#define LIBB_API // static linking
#endif

namespace my
{

LIBB_API
extern const int c_uLibBVersion;

} // namespace my
