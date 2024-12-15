// https://en.cppreference.com/w/cpp/feature_test
//
// We don't care about testing C++ standards earlier than C++11.
//
#pragma once

#ifndef __has_include
#error "__has_include is not supported"
#endif

// C compat
//
#include <cstdarg>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>

// types and containers
//
#if defined(__cpp_lib_any)
#include <any> // C++17
#endif
#include <array> // C++11
#if defined(__cpp_lib_bitset)
#include <bitset> // C++26
#endif
#if defined(__cpp_lib_complex)
#include <complex> // C++11
#endif
#include <deque> // C++11
#if defined(__cpp_lib_flat_map)
#include <flat_map> // C++23
#endif
#if defined(__cpp_lib_flat_set)
#include <flat_set> // C++23
#endif
// #include <hash_map> // surpassed by <unordered_map>
// #include <hash_set> // surpassed by <unordered_set>
#include <list> // C++11
#include <map> // C++11
#include <queue> // C++11
#include <set> // C++11
#if defined(__cpp_lib_span)
#include <span> // C++20
#endif
#include <stack> // C++11
#include <string> // C++11
#if defined(__cpp_lib_string_view)
#include <string_view> // C++17
#endif
#include <tuple> // C++11
#include <unordered_map> // C++11
#include <unordered_set> // C++11
#if defined(__cpp_lib_variant)
#include <variant> // C++17
#endif
#include <vector> // C++11

// io
//
#include <iostream>
#if defined(__cpp_lib_filesystem)
#include <filesystem> // C++17
#endif

// utilities
//
#include <algorithm> // C++11
#if defined(__cpp_lib_bit_cast)
#include <bit> // C++20
#endif
#if defined(__cpp_lib_to_chars)
#include <charconv> // C++17
#endif
#if defined(__cpp_lib_chrono)
#include <chrono> // general C++17
#endif
#if defined(__cpp_lib_concepts)
#include <concepts> // C++20
#endif
#if defined(__cpp_lib_three_way_comparison)
#include <compare> // C++20
#endif
#if defined(__cpp_lib_expected)
#include <expected> // C++23
#endif
#if defined(__cpp_lib_format)
#include <format> // C++20
#endif
#include <functional> // C++11
#if defined(__cpp_initializer_lists)
#include <initializer_list> // C++11
#endif
#include <limits> // C++11
#include <numeric> // C++11
#if defined(__cpp_lib_optional)
#include <optional> // C++17
#endif
#if defined(__cpp_lib_print)
#include <print> // C++23
#endif
#if defined(__cpp_lib_ranges)
#include <ranges> // C++20
#endif
#include <type_traits> // C++14
#include <utility> // C++11

// memory management
//
#include <memory> // C++11
#if defined(__cpp_lib_polymorphic_allocator)
#include <memory_resource> // C++17
#endif
#include <new> // C++11
#if __has_include(<scoped_allocator>)
#include <scoped_allocator> // C++11
#endif

// concurrency and parallelism (multi-threading)
//
#include <atomic> // C++11
#if defined(__cpp_lib_barrier)
#include <barrier> // C++20
#endif
// <condition_variable> is not supported when compiling with /clr
#if !defined(__cplusplus_cli) && !defined(_MANAGED)
#if __has_include(<condition_variable>)
#include <condition_variable> // C++11
#endif
#endif // !defined(__cplusplus_cli) && !defined(_MANAGED)
#if defined(__cpp_lib_coroutine)
#include <coroutine> // C++20
#endif
#if defined(__cpp_lib_execution)
#include <execution> // C++17
#endif
#if __has_include(<future>)
#include <future> // C++11
#endif
#if defined(__cpp_lib_generator)
#include <generator> // C++23
#endif
#if defined(__cpp_lib_latch)
#include <latch> // C++20
#endif
#include <mutex> // C++11
#if defined(__cpp_lib_shared_mutex)
#include <shared_mutex> // C++17
#endif
#if defined(__cpp_lib_stacktrace)
#include <stacktrace> // C++23
#endif
#include <thread> // C++11
