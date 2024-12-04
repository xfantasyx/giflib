include(${CMAKE_CURRENT_LIST_DIR}/giflib.cmake)

set(GIF_FOUND TRUE)

if(TARGET giflib::giflib)

    get_target_property(GIF_INCLUDE_DIRS giflib::giflib INTERFACE_INCLUDE_DIRECTORIES)
    set(GIF_LIBRARIES giflib::giflib)

endif()