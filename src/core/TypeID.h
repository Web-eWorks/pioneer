// This file is part of the Trinity Engine, Copyright (c) 2020 Web eWorks, LTD.
//
// This file is derived from an altered version of TwoECS, released under the
// terms of the Zlib License
// Copyright (c) 2020 stillwwater. See licenses/zlib.txt

#pragma once

#include <cstddef>
#include <cstdint>
#include <type_traits>

// Compile time id for a given type.
static_assert(std::is_same<size_t, std::uintptr_t>::value,
	"Type ID must be the same size as pointer type!");

namespace internal {
	template <typename T>
	struct TypeIdInfo {
		static const size_t *const value;
	};

	template <typename T>
	const size_t *const TypeIdInfo<T>::value = nullptr;
} // namespace internal

// Compile time typeid.
// TODO: this version will not work across boundaries. Evaluate the use of e.g. PRETTY_FUNCTION.
template <typename T>
constexpr size_t type_id()
{
	using actual_type_t = typename std::remove_pointer<typename std::decay<T>::type>::type;
	return reinterpret_cast<std::uintptr_t>(static_cast<const void *>(&internal::TypeIdInfo<actual_type_t>::value));
}
