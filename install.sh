#!/bin/bash
#
# Copyright 2015 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#####################################################
exec 1> >(logger -s -t $(basename $0)) 2>&1

ADD_IPSEC_DIR_SRC="https://raw.githubusercontent.com/bmcsheehy/softlayer_vyatta/master/add_ipsec_conf"
ADD_IPSEC_DIR_LOCAL="/opt/vyatta/sbin/add_ipsec_conf"
IPSEC_SYMLINK="/etc/commit/post-hooks.d/02add_ipsec_conf"

echo "* checking for add_ipsec_conf"
if [  ! -e $ADD_IPSEC_DIR_LOCAL ];
    then
        echo "* unable to find add_ipsec_conf, downloading"
        curl -s -o $ADD_IPSEC_DIR_LOCAL -k $ADD_IPSEC_DIR_SRC
        if [  ! -e $ADD_IPSEC_DIR_LOCAL ];
            then
                "error: unable to download add_ipsec_conf"
                exit
        else
            echo "* file downloaded successfully"
        fi
else
    echo "* add_ipsec_conf found"
fi

echo "* checking file permissions"
if [ ! -x $ADD_IPSEC_DIR_LOCAL ];
    then
        echo "* adding file permissions"
        chmod 755 $ADD_IPSEC_DIR_LOCAL
else
    echo "* looks good"
fi

echo "* checking for symlink"
if [ ! -L $IPSEC_SYMLINK ];
    then
        echo "* adding symlink"
        ln -s $ADD_IPSEC_DIR_LOCAL $IPSEC_SYMLINK
else
    echo "* looks good"
fi


echo "* executing update"
exec $IPSEC_SYMLINK
echo "* complete!"
