#!/bin/bash
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

set -e

## Bootstrap
./script/bootstrap.sh

## Override default travis cmake
export PATH="${HOME}/.local/bin:$PATH"

CMAKE_GEN="$([ "$TRAVIS_OS_NAME" != "osx" ] && echo "Ninja" || echo "Unix Makefiles")"
readonly CMAKE_GEN

## Build commissioner
mkdir -p build && cd build
cmake -G "${CMAKE_GEN}" \
      -DBUILD_SHARED_LIBS="${OT_COMM_SHARED_LIB:=OFF}" \
      -DCMAKE_CXX_STANDARD="${OT_COMM_CXX_STANDARD}" \
      -DCMAKE_CXX_STANDARD_REQUIRED=ON \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DOT_COMM_COVERAGE=ON ..
[ "$CMAKE_GEN" == "Ninja" ] && ninja || make -j2

## Install
if [ "$CMAKE_GEN" == "Ninja" ]; then
    sudo ninja install
else
    sudo make install
fi

commissioner-cli -h

## Unit tests
./tests/commissioner-test

## Integration Tests
if [ $TRAVIS_OS_NAME = "linux" ] && [ ${OT_COMM_CXX_STANDARD} = "11" ]; then
    if [ $CC = gcc ]; then
        ## Integration tests
        cd ../tests/integration
        ./bootstrap.sh
        ./run_tests.sh
    fi
fi
