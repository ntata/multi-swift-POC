#!/bin/sh

#Author: Paul Dardeau <paul.dardeau@intel.com>
#        Nandini Tata <nandini.tata@intel.com>
# Copyright (c) 2016 OpenStack Foundation
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



###################################################
#Script ot install all required dependencies before 
#installing Swift
###################################################

#trusty backports mirror contains liberasurecode=dev
apt-add-repository "deb http://us.archive.ubuntu.com/ubuntu trusty-backports main universe"

apt-get update
apt-get install -y curl
apt-get install -y gcc
apt-get install -y memcached
apt-get install -y rsync
apt-get install -y sqlite3
apt-get install -y xfsprogs
apt-get install -y git-core
apt-get install -y libffi-dev
apt-get install -y python-setuptools
apt-get install -y liberasurecode-dev
apt-get install -y libssl-dev
apt-get install -y python-coverage
apt-get install -y python-dev
apt-get install -y python-nose
apt-get install -y python-xattr
apt-get install -y python-eventlet
apt-get install -y python-greenlet
apt-get install -y python-pastedeploy
apt-get install -y python-netifaces
apt-get install -y python-dnspython
apt-get install -y python-mock
apt-get install -y  libpython3.4-dev

#ubuntu 14.04 comes with older pip version. We get the latest version here
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py


apt-get remove -y python-six
yes | pip install -U six
yes | pip install -U pip tox pbr virtualenv setuptools
yes | pip install PyECLib


#wget https://github.com/ntata/swift/blob/master/requirements.txt
#https://github.com/ntata/swift/blob/master/test-requirements.txt

#pip install -r requirements.txt
#pip install -r test-requirements.txt

