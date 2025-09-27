include_directories(${CMAKE_SOURCE_DIR})

include(transform)

# please keep the list sorted
set(fast_rnnt_srcs
  fast_rnnt.cu
  mutual_information.cu
)

if(NOT FT_WITH_CUDA)
  transform(OUTPUT_VARIABLE fast_rnnt_srcs SRCS ${fast_rnnt_srcs})
endif()


pybind11_add_module(_fast_rnnt ${fast_rnnt_srcs})
target_link_libraries(_fast_rnnt PRIVATE mutual_information_core)

if(_FT_WITH_HIP AND NOT _FT_WITH_CUDA)
  # Pass HIP arch flags when compiling GPU objects as part of the module, if any
  target_compile_options(_fast_rnnt PRIVATE --amdgpu-target=${AMDGPU_TARGETS})
  foreach(src IN LISTS fast_rnnt_srcs)
    if(src MATCHES ".*\\.cu$")
      set_source_files_properties(${src} PROPERTIES LANGUAGE HIP)
    endif()
  endforeach()
  target_link_libraries(_fast_rnnt PRIVATE HIP::device)
endif()

if(APPLE)
  target_link_libraries(_fast_rnnt
    PRIVATE
      ${TORCH_DIR}/lib/libtorch_python.dylib
  )
elseif(UNIX)
  target_link_libraries(_fast_rnnt
    PRIVATE
      ${PYTHON_LIBRARY}
      ${TORCH_DIR}/lib/libtorch_python.so
  )
endif()
