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

# Offline-friendly pybind11 discovery: use installed Python package

if(NOT DEFINED PYTHON_EXECUTABLE AND NOT Python3_Interpreter_FOUND)
  find_package(Python3 COMPONENTS Interpreter REQUIRED)
  set(PYTHON_EXECUTABLE ${Python3_EXECUTABLE} CACHE INTERNAL "")
endif()

# Try to locate pybind11's CMake package via Python
set(_PYBIND11_CMAKE_DIR "")
if(PYTHON_EXECUTABLE)
  execute_process(
    COMMAND "${PYTHON_EXECUTABLE}" -c "import sys;\ntry:\n import pybind11, os; print(pybind11.get_cmake_dir())\nexcept Exception:\n print('')\n"
    OUTPUT_STRIP_TRAILING_WHITESPACE
    OUTPUT_VARIABLE _PYBIND11_CMAKE_DIR
  )
endif()

if(_PYBIND11_CMAKE_DIR AND EXISTS "${_PYBIND11_CMAKE_DIR}")
  list(APPEND CMAKE_PREFIX_PATH "${_PYBIND11_CMAKE_DIR}")
endif()

find_package(pybind11 CONFIG QUIET)
if(NOT pybind11_FOUND)
  message(FATAL_ERROR "pybind11 not found. Please install it into the Python environment (e.g., pip install --no-index --find-links=<mirror> pybind11) or set PYBIND11_DIR.")
endif()
