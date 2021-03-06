#
#  Copyright (c) 2019, The OpenThread Authors.
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#  3. Neither the name of the copyright holder nor the
#     names of its contributors may be used to endorse or promote products
#     derived from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
#  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
#  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
#  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY OF SUCH DAMAGE.
#

add_library(commissioner-app)

target_sources(commissioner-app
    PRIVATE
        commissioner_app.cpp
        commissioner_app.hpp
        border_agent.cpp
        border_agent.hpp
        file_logger.cpp
        file_logger.hpp
        file_util.cpp
        file_util.hpp
        json.cpp
        json.hpp
)

target_link_libraries(commissioner-app
    PUBLIC
        commissioner
        commissioner-common
    PRIVATE
        fmt::fmt
        mdns
        nlohmann_json::nlohmann_json
)

target_include_directories(commissioner-app
    PRIVATE
        ${PROJECT_SOURCE_DIR}/src
)

install(DIRECTORY etc/commissioner
        FILE_PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ
        DESTINATION etc
)

if (BUILD_SHARED_LIBS)
    install(TARGETS commissioner-app
            LIBRARY DESTINATION lib
            ARCHIVE DESTINATION lib
    )
endif()

add_library(commissioner-app-test EXCLUDE_FROM_ALL)

target_sources(commissioner-app-test
    PRIVATE
        json.hpp
        json_test.cpp
)

target_include_directories(commissioner-app-test
    PRIVATE
        ${PROJECT_SOURCE_DIR}/src
)

target_link_libraries(commissioner-app-test
    PRIVATE
        Catch2::Catch2
        commissioner-app
        nlohmann_json::nlohmann_json
)

add_subdirectory(cli)
