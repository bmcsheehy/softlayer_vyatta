#!/bin/bash

ADD_IPSEC_DIR_SRC="https://raw.githubusercontent.com/bmcsheehy/softlayer_vyatta/master/add_ipsec_conf"
ADD_IPSEC_DIR_LOCAL="/opt/vyatta/sbin/add_ipsec_conf"
IPSEC_SYMLINK="/etc/commit/post-hooks.d/02add_ipsec_conf"

echo "* checking for add_ipsec_conf"
if [  ! -e $ADD_IPSEC_DIR_LOCAL ];
    then
        echo "* unable to find add_ipsec_conf, downloading"
        curl -s -o $ADD_IPSEC_DIR_LOCAL $ADD_IPSEC_DIR_SRC
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

echo "* success!"
