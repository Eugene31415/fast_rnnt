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

function(download_pybind11)
  if(CMAKE_VERSION VERSION_LESS 3.11)
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/Modules)
  endif()

  include(FetchContent)

  # Use a newer pybind11 compatible with Python 3.13 (2.12+)
  set(pybind11_GIT_REPOSITORY  "https://github.com/pybind/pybind11.git")
  set(pybind11_GIT_TAG        "v2.12.0")

  set(double_quotes "\"")
  set(dollar "\$")
  set(semicolon "\;")
  FetchContent_Declare(pybind11
    GIT_REPOSITORY ${pybind11_GIT_REPOSITORY}
    GIT_TAG        ${pybind11_GIT_TAG}
  )

  FetchContent_GetProperties(pybind11)
  if(NOT pybind11_POPULATED)
    message(STATUS "Downloading pybind11")
    FetchContent_Populate(pybind11)
  endif()
  message(STATUS "pybind11 is downloaded to ${pybind11_SOURCE_DIR}")
  add_subdirectory(${pybind11_SOURCE_DIR} ${pybind11_BINARY_DIR} EXCLUDE_FROM_ALL)
endfunction()

download_pybind11()
