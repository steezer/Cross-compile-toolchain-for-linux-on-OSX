cmake_minimum_required(VERSION 3.1)
include(/Develop/config/cmake/linux.cmake)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED true)
set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-pthread")
project(test C CXX)

aux_source_directory(./src SRC)
add_executable(app ${SRC})
