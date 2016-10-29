#!/bin/bash

#Author: Paul Dardeau <paul.dardeau@intel.com>
#        Nandini Tata <nandini.tata@intel.com>
# Copyright (c) 2016 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.


########################
# creates openrc file
#######################

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
   exit 1
fi

SWIFT_GROUP=swift

for i in `more clusters.txt`; do
   SWIFT_USER_HOME=/home/swift-${i}
   SWIFT_USER=swift-${i}

   cd ${SWIFT_USER_HOME}
   PROXY_PORT=$(find /etc/${SWIFT_USER} -name "proxy-server.conf" -exec sed -n 's/bind_port = \([0-9]*\)/\1/p' {} \;)
   echo  "export ST_AUTH=http://127.0.0.1:${PROXY_PORT}/auth/v1.0
   export ST_USER=test:tester
   export ST_KEY=testing
   export SWIFT_ROOT=/etc/${SWIFT_USER}
   export SWIFT_RUN_DIR=/var/run/${SWIFT_USER}
   export SWIFT_XPROFILE_DIR=/tmp/log/${SWIFT_USER}" >openrc
   chown ${SWIFT_USER}:${SWIFT_GROUP} openrc
   cd -
   cp start_swift.sh ${SWIFT_USER_HOME}
   chown ${SWIFT_USER}:${SWIFT_GROUP} ${SWIFT_USER_HOME}/start_swift.sh
   cp stop_swift.sh ${SWIFT_USER_HOME}
   chown ${SWIFT_USER}:${SWIFT_GROUP} ${SWIFT_USER_HOME}/stop_swift.sh
done
