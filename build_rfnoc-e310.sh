#!/bin/bash

#############################################################################################
#############################################################################################
#
#   The MIT License (MIT)
#   
#   Copyright (c) 2021 http://odelay.io 
#   
#   Permission is hereby granted, free of charge, to any person obtaining a copy
#   of this software and associated documentation files (the "Software"), to deal
#   in the Software without restriction, including without limitation the rights
#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#   copies of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be included in all
#   copies or substantial portions of the Software.
#   
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#   SOFTWARE.
#   
#   Contact : <everett@odelay.io>
#  
#   Description : Build script for GNURadio with RFNoC
#
#   Version History:
#   
#       Date        Description
#     -----------   -----------------------------------------------------------------------
#      12FEB2021     Original Creation
#
###########################################################################################
#
#   Development Notes:
#       
#       
#       sudo docker build -t rfnoc-310:v0.1 ./
#       
#       Based on the following instructions:
#         https://kb.ettus.com/Software_Development_on_the_E3xx_USRP_-_Building_RFNoC_UHD_/_GNU_Radio_/_gr-ettus_from_Source
#
#       Save the Docker Image after building RFNoC:
#         docker ps -a
#
#       Commit command:
#         docker commit [CONTAINER_ID] [new_image_name]
#
#       Example:
#         docker commit deddd39fa163 rfnoc-e310:v0.2
#
#
#
#############################################################################################
#############################################################################################

#------------------------------------------------------------------------------------------
# This will make apt-get install without question
#------------------------------------------------------------------------------------------
INSTALL_BASE=/home/sdr
DEBIAN_FRONTEND=noninteractive
UHD_TAG=v3.14.1.1 
GR_TAG=maint-3.7


rm -rf /var/lib/apt/lists/*

#------------------------------------------------------------------------------------------
#       Install Python Future
#------------------------------------------------------------------------------------------
cd $INSTALL_BASE
wget https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz
tar -zxvf future-0.18.2.tar.gz 
cd ./future-0.18.2
python setup.py install

# clear up
cd $INSTALL_BASE
rm -fr ./future-0.18.2
rm -fr ./future-0.18.2.tar.gz

#------------------------------------------------------------------------------------------
#       Create Development Workspace
#------------------------------------------------------------------------------------------
#mkdir -p $INSTALL_BASE/rfnoc
#mkdir -p $INSTALL_BASE/rfnoc/oe
#mkdir -p $INSTALL_BASE/rfnoc/e300
#mkdir -p $INSTALL_BASE/rfnoc/src


#------------------------------------------------------------------------------------------
#     Installing UHD
#------------------------------------------------------------------------------------------
cd $INSTALL_BASE/rfnoc/src
git clone https://github.com/EttusResearch/uhd.git 
cd $INSTALL_BASE/rfnoc/src/uhd 
git checkout $UHD_TAG 
git submodule update --init --recursive
mkdir -p $INSTALL_BASE/rfnoc/src/uhd/host/build-host
cd $INSTALL_BASE/rfnoc/src/uhd/host/build-host
cmake -DENABLE_E300=ON -DENABLE_GPSD=ON -DENABLE_RFNOC=ON ..
make -j4
make install
ldconfig
uhd_images_downloader


#------------------------------------------------------------------------------------------
#     Installing VOLK, but didn't work
#------------------------------------------------------------------------------------------
#   git clone https://github.com/gnuradio/volk.git $INSTALL_BASE/rfnoc/src/volk 
#   cd $INSTALL_BASE/rfnoc/src/volk 
#   git submodule update --init --recursive
#   mkdir -p $INSTALL_BASE/rfnoc/src/volk/build
#   cd $INSTALL_BASE/rfnoc/src/volk/build
#   cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 -DCMAKE_INSTALL_PREFIX=/usr ../
#   make -j $MAKEWIDTH
#   make install
#   ldconfig


#------------------------------------------------------------------------------------------
#   Installing GNU Radio
#------------------------------------------------------------------------------------------
cd $INSTALL_BASE/rfnoc/src
git clone https://github.com/gnuradio/gnuradio.git 
cd $INSTALL_BASE/rfnoc/src/gnuradio 
git checkout $GR_TAG 
git submodule update --init --recursive
mkdir -p $INSTALL_BASE/rfnoc/src/gnuradio/build-host
cd $INSTALL_BASE/rfnoc/src/gnuradio/build-host
cmake ..
make -j4
make install
ldconfig


#------------------------------------------------------------------------------------------
#   Installing GR-Ettus
#------------------------------------------------------------------------------------------
cd $INSTALL_BASE/rfnoc/src
git clone https://github.com/EttusResearch/gr-ettus.git 
cd $INSTALL_BASE/rfnoc/src/gr-ettus 
git checkout $GR_TAG
git submodule update --init --recursive
mkdir -p $INSTALL_BASE/rfnoc/src/gr-ettus/build-host
cd $INSTALL_BASE/rfnoc/src/gr-ettus/build-host
cmake .. 
make -j4
make install
ldconfig


#------------------------------------------------------------------------------------------
#   Installing Cross-compiler for SDK
#------------------------------------------------------------------------------------------
cd $INSTALL_BASE/rfnoc/src
wget http://files.ettus.com/e3xx_images/e3xx-release-4/oecore-x86_64-armv7ahf-vfp-neon-toolchain-nodistro.0.sh
bash oecore-x86_64-armv7ahf-vfp-neon-toolchain-nodistro.0.sh -y -d $INSTALL_BASE/rfnoc/oe

cd $INSTALL_BASE/rfnoc/oe
source ./environment-setup-armv7ahf-vfp-neon-oe-linux-gnueabi 

#------------------------------------------------------------------------------------------
#     Installing Cross-compiler for UHD
#------------------------------------------------------------------------------------------
mkdir -p $INSTALL_BASE/rfnoc/src/uhd/host/build-arm
cd $INSTALL_BASE/rfnoc/src/uhd/host/build-arm
cmake -DCMAKE_TOOLCHAIN_FILE=../host/cmake/Toolchains/oe-sdk_cross.cmake \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DENABLE_E300=ON \
      -DENABLE_GPSD=ON \
      -DENABLE_RFNOC=ON ..
make -j4
make install DESTDIR=$INSTALL_BASE/rfnoc/e300
make install DESTDIR=$INSTALL_BASE/rfnoc/oe/sysroots/armv7ahf-vfp-neon-oe-linux-gnueabi/


#------------------------------------------------------------------------------------------
#     Create a file with the below text located in $INSTALL_BASE/rfnoc/e300/setup.env
#------------------------------------------------------------------------------------------
#         LOCALPREFIX=~/newinstall/usr
#         export PATH=$LOCALPREFIX/bin:$PATH
#         export LD_LOAD_LIBRARY=$LOCALPREFIX/lib:$LD_LOAD_LIBRARY
#         export LD_LIBRARY_PATH=$LOCALPREFIX/lib:$LD_LIBRARY_PATH
#         export PYTHONPATH=$LOCALPREFIX/lib/python2.7/site-packages:$PYTHONPATH
#         export PKG_CONFIG_PATH=$LOCALPREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
#         export GRC_BLOCKS_PATH=$LOCALPREFIX/share/gnuradio/grc/blocks:$GRC_BLOCKS_PATH
#         export UHD_RFNOC_DIR=$LOCALPREFIX/share/uhd/rfnoc/
#         export UHD_IMAGES_DIR=$LOCALPREFIX/share/uhd/images



#------------------------------------------------------------------------------------------
#     Copy default FPGA Images to workspace
#------------------------------------------------------------------------------------------
mkdir -p $INSTALL_BASE/rfnoc/e300/usr/share/uhd/images
cd $INSTALL_BASE/rfnoc/e300/usr/share/uhd/images
cp -Rv /usr/local/share/uhd/images/usrp_e310_fpga* .
cp -Rv /usr/local/share/uhd/images/usrp_e3xx_fpga_idle* .




#------------------------------------------------------------------------------------------
#   Installing Cross-compiler for OE SDK
#------------------------------------------------------------------------------------------
cd $INSTALL_BASE/rfnoc/src
wget https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz
tar -zxvf six-1.11.0.tar.gz
cd ./six-1.11.0
python setup.py install --prefix=$INSTALL_BASE/rfnoc/oe/sysroots/x86_64-oesdk-linux/usr




#------------------------------------------------------------------------------------------
#   Installing Cross-compiler for GNU Radio
#------------------------------------------------------------------------------------------
mkdir -p $INSTALL_BASE/rfnoc/src/gnuradio/build-arm
cd $INSTALL_BASE/rfnoc/src/gnuradio/build-arm
cmake -Wno-dev \
      -DCMAKE_TOOLCHAIN_FILE=$INSTALL_BASE/rfnoc/src/gnuradio/cmake/Toolchains/oe-sdk_cross.cmake \
      -DENABLE_GR_WXGUI=OFF \
      -DENABLE_GR_VOCODER=OFF \
      -DENABLE_GR_DTV=OFF \
      -DENABLE_GR_ATSC=OFF \
      -DENABLE_DOXYGEN=OFF \
      -DENABLE_GR_CTRLPORT=OFF \
      -DCMAKE_INSTALL_PREFIX=/usr \
      ../
make -j4
make install DESTDIR=$INSTALL_BASE/rfnoc/e300
make install DESTDIR=$INSTALL_BASE/rfnoc/oe/sysroots/armv7ahf-vfp-neon-oe-linux-gnueabi



#------------------------------------------------------------------------------------------
#   Installing Cross-compiler for gr-ettus
#------------------------------------------------------------------------------------------
cd $INSTALL_BASE/rfnoc/src/gr-ettus
mkdir -p build-arm
cd ./build-arm
cmake -DCMAKE_TOOLCHAIN_FILE=$INSTALL_BASE/rfnoc/src/gnuradio/cmake/Toolchains/oe-sdk_cross.cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make -j4
make install DESTDIR=$INSTALL_BASE/rfnoc/e300/
make install DESTDIR=$INSTALL_BASE/rfnoc/oe/sysroots/armv7ahf-vfp-neon-oe-linux-gnueabi/



