cmake_minimum_required(VERSION 3.2)

project(giflib C)

execute_process(COMMAND ./getversion
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(LIBMAJOR 5)
set(LIBMINOR 2)
set(LIBPOINT 1)
set(LIBVER "${LIBMAJOR}.${LIBMINOR}.${LIBPOINT}")

set(giflib_SRC
    dgif_lib.c
    egif_lib.c
    getarg.c
    gifalloc.c
    gif_err.c
    gif_font.c
    gif_hash.c
    openbsd-reallocarray.c
    qprintf.c
    quantize.c
)

# # Some utilities are installed
# set(giflib_INSTALLABLE
#     gif2rgb
#     gifbuild
#     gifecho
#     giffilter
#     giffix
#     gifinto
#     giftext
#     giftool
#     gifsponge
#     gifclrmp
# )

# # Some utilities are only used internally for testing.
# # There is a parallel list in doc/Makefile.
# # These are all candidates for removal in future releases.
# set(giflib_UTILS
#     ${giflib_INSTALLABLE}
#     gifbg
#     gifcolor
#     gifhisto
#     gifwedge
# )


add_library(giflib ${giflib_SRC})

set_target_properties(giflib PROPERTIES VERSION ${LIBVER} SOVERSION ${LIBMAJOR})

# foreach(UTILITY ${giflib_UTILS})
#     add_executable(${UTILITY} ${UTILITY}.c)
#     target_link_libraries(${UTILITY} giflib)
# endforeach()


target_compile_definitions(giflib
  PRIVATE
  _CRT_SECURE_NO_WARNINGS
  _CRT_STDC_NO_DEPRECATE
)

target_include_directories(giflib PUBLIC $<INSTALL_INTERFACE:include>)

IF (UNIX AND NOT WINDOWS)
    FIND_PROGRAM(CMAKE_UNAME uname /bin /usr/bin /usr/local/bin )
    IF (CMAKE_UNAME)
        EXEC_PROGRAM(uname ARGS -m OUTPUT_VARIABLE CMAKE_SYSTEM_PROCESSOR)
        SET(CMAKE_SYSTEM_PROCESSOR ${CMAKE_SYSTEM_PROCESSOR} CACHE INTERNAL
"processor type (i386 and x86_64)")
        IF(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64")
            ADD_DEFINITIONS(-fPIC)
        ENDIF(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64")
    ENDIF(CMAKE_UNAME)
ENDIF(UNIX AND NOT WINDOWS)

IF (DARWIN)
    ADD_DEFINITIONS(-fPIC)
ENDIF()



include(CMakePackageConfigHelpers)

write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake
  VERSION ${LIBVER}
  COMPATIBILITY AnyNewerVersion
)

install(TARGETS giflib EXPORT giflib
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)


install(FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/gif_lib.h
  DESTINATION include
)

install(EXPORT giflib
  FILE
  ${PROJECT_NAME}.cmake
  NAMESPACE
    ${PROJECT_NAME}::
  DESTINATION
    cmake
)


install(
  FILES
    cmake/${PROJECT_NAME}-config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake
  DESTINATION
    cmake
)

export(TARGETS giflib
  FILE
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config.cmake
  NAMESPACE ${PROJECT_NAME}::
)