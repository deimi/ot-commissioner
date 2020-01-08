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

[ -z ${TEST_ROOT_DIR} ] && . $(dirname $0)/common.sh

test_ccm_nmkp_joining() {
    set -e

    start_registrar
    start_otbr "${CCM_NCP}" "${REGISTRAR_IF}"
    form_network ${PSKC}

    start_commissioner ${CCM_CONFIG}
    send_command_to_commissioner "token request ${REGISTRAR_IP} 5684"
    send_command_to_commissioner "start :: 49191"
    send_command_to_commissioner "active"

    ## enable all CCM AE joiners
    send_command_to_commissioner "joiner enableall ae"
    start_joiner "ae"

    ## enable all CCM NMKP joiners
    send_command_to_commissioner "joiner enableall nmkp"
    start_joiner "nmkp"

    stop_commissioner
}

test_ccm_nmkp_joining_fail() {
    start_registrar
    start_otbr "${CCM_NCP}" "${REGISTRAR_IF}"
    form_network ${PSKC}

    start_commissioner ${CCM_CONFIG}
    send_command_to_commissioner "token request ${REGISTRAR_IP} 5684"
    send_command_to_commissioner "start :: 49191"
    send_command_to_commissioner "active"

    ## enable all CCM AE joiners
    send_command_to_commissioner "joiner enableall ae"
    start_joiner "ae"

    ## CCM NMKP joiners not enabled, it should fail.
    start_joiner "nmkp" && return 1

    stop_commissioner
}