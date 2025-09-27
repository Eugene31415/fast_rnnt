# Copyright (c)  2021  Xiaomi Corporation (authors: Fangjun Kuang)
# See ../LICENSE for clarification regarding multiple authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Offline-friendly pybind11 integration
# - Prefer headers discovered from the active Python (pybind11.get_include())
# - Alternatively, allow users to pass -DPYBIND11_INCLUDE_DIR=/path/to/pybind11/include
# - Provide a lightweight pybind11_add_module() that avoids network fetches

if(NOT DEFINED PYBIND11_INCLUDE_DIR)
  execute_process(
    COMMAND "${PYTHON_EXECUTABLE}" -c "import pybind11, sys; print(pybind11.get_include())"
    OUTPUT_STRIP_TRAILING_WHITESPACE
    OUTPUT_VARIABLE PYBIND11_INCLUDE_DIR
    RESULT_VARIABLE PYBIND11_GET_INCLUDE_RC
  )
  if(NOT PYBIND11_GET_INCLUDE_RC EQUAL 0)
    message(FATAL_ERROR "Could not locate pybind11 headers.\n"
      "Either install pybind11 in your Python environment offline, or pass "
      "-DPYBIND11_INCLUDE_DIR=/path/to/pybind11/include to CMake.")
  endif()
endif()

message(STATUS "Using pybind11 headers at: ${PYBIND11_INCLUDE_DIR}")

function(pybind11_add_module target)
  add_library(${target} MODULE ${ARGN})
  target_include_directories(${target} PRIVATE ${PYBIND11_INCLUDE_DIR})
  # Ensure Python module has no 'lib' prefix on UNIX
  set_target_properties(${target} PROPERTIES PREFIX "")
  # Position-independent code is typical for modules
  set_target_properties(${target} PROPERTIES POSITION_INDEPENDENT_CODE ON)
endfunction()
