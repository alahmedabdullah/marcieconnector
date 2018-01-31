#!/bin/sh
# version 2.0

WORK_DIR=`pwd`

MARCIE_PACKAGE_NAME=$(sed 's/MARCIE_PACKAGE_NAME=//' $WORK_DIR/package_metadata.txt)
mv $WORK_DIR/$MARCIE_PACKAGE_NAME /opt
cd /opt

tar -zxvf $MARCIE_PACKAGE_NAME
marcie_exe=$(whereis marcie 2>&1 | awk '/marcie/ {print $2}')
mv $marcie_exe /usr/local/bin

cd $WORK_DIR
