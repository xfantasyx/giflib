include(${CMAKE_CURRENT_LIST_DIR}/giflib.cmake)

set(GIF_FOUND TRUE)

if(TARGET giflib::giflib)

    get_target_property(GIF_INCLUDE_DIRS giflib::giflib INTERFACE_INCLUDE_DIRECTORIES)
    set(GIF_LIBRARIES giflib::giflib)

    if(NOT TARGET GIF::GIF)
        add_library(GIF::GIF INTERFACE IMPORTED)

        set_target_properties(GIF::GIF PROPERTIES
        INTERFACE_LINK_LIBRARIES giflib::giflib
        )
    endif()

endif()

