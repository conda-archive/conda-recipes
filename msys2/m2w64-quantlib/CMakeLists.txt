cmake_minimum_required(VERSION 1.15)

project(quantlib CXX)

include_directories(
	include
)

file(
	GLOB
	source_files
	src/*.cpp
)

add_library(
	quantlib
	SHARED
	${source_files}
)

file(
	GLOB
	header_files
	include/*
)

install(
    TARGETS quantlib
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)

install(
	FILES ${header_files} DESTINATION include
)
