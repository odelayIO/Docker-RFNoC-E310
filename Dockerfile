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
#   Description : Docker File for E310 RFNoC Developement with Xilinx HLS
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
#       sudo docker build -t rfnoc-e310:v0.1 ./
#       
#       Based on the following instructions:
#         https://kb.ettus.com/Software_Development_on_the_E3xx_USRP_-_Building_RFNoC_UHD_/_GNU_Radio_/_gr-ettus_from_Source
#
#       How to Delete the Docker Image:
#         sudo docker rmi --force ettusresearch/ubuntu-uhd-gnuradio ettusresearch/ubuntu-uhd-gnuradio
#
#       Save the Docker Image after building RFNoC:
#         docker ps -a
#
#       Commit command:
#         docker commit [CONTAINER_ID] [new_image_name]
#
#         Example:
#           docker commit deddd39fa163 rfnoc-e310:v0.2
#
#############################################################################################
#############################################################################################

FROM        ubuntu:18.04
MAINTAINER  http://odelay.io

#------------------------------------------------------------------------------------------
# Last build date - this can be updated whenever there are security updates so
# that everything is rebuilt
#------------------------------------------------------------------------------------------
ENV         security_updates_as_of 2020-05-01

#------------------------------------------------------------------------------------------
# This will make apt-get install without question
#------------------------------------------------------------------------------------------
ARG         INSTALL_BASE=/home/sdr
ARG         DEBIAN_FRONTEND=noninteractive
ARG         UHD_TAG=v3.14.1.1 
ARG         GR_TAG=maint-3.7


#------------------------------------------------------------------------------------------
#     Installing recommended and personal packages
#------------------------------------------------------------------------------------------


RUN       apt-get update \
          && apt-get -y install -q \
          build-essential \
          git \
          swig \
          cmake \
          doxygen \
          libboost-all-dev \
          libtool \ 
          libusb-1.0-0 \
          libusb-1.0-0-dev \
          libudev-dev \
          libncurses5-dev \
          libfftw3-bin \
          libfftw3-dev \
          libfftw3-doc \
          libcppunit-1.14-0 \
          libcppunit-dev \
          libcppunit-doc \
          ncurses-bin \
          cpufrequtils \
          python-numpy \
          python-numpy-doc \
          python-numpy-dbg \
          python-scipy \
          python-docutils \
          qt4-bin-dbg \
          qt4-default \
          qt4-doc \
          libqt4-dev \
          libqt4-dev-bin \
          python-qt4 \
          python-qt4-dbg \
          python-qt4-dev \
          python-qt4-doc \
          python-qt4-doc \
          libqwt6abi1 \
          libfftw3-bin \
          libfftw3-dev \
          libfftw3-doc \
          ncurses-bin \
          libncurses5 \
          libncurses5-dev \
          libncurses5-dbg \
          libfontconfig1-dev \
          libxrender-dev \
          libpulse-dev \
          swig \
          g++ \
          automake \
          autoconf \
          libtool \
          python-dev \
          libfftw3-dev \
          libcppunit-dev \
          libboost-all-dev \
          libusb-dev \
          libusb-1.0-0-dev \
          fort77 \
          libsdl1.2-dev \
          python-wxgtk3.0 \
          git \
          libqt4-dev \
          python-numpy \
          ccache \
          python-opengl \
          libgsl-dev \
          python-cheetah \
          python-mako \
          python-lxml \
          doxygen \
          qt4-default \
          qt4-dev-tools \
          libusb-1.0-0-dev \
          libqwtplot3d-qt5-dev \
          pyqt4-dev-tools \
          python-qwt5-qt4 \
          cmake \
          git \
          wget \
          libxi-dev \
          gtk2-engines-pixbuf \
          r-base-dev python-tk \
          liborc-0.4-0 \
          liborc-0.4-dev \
          libasound2-dev \
          python-gtk2 \
          libzmq3-dev \
          libzmq5 \
          python-requests \
          python-sphinx \
          libcomedi-dev \
          python-zmq \
          libqwt-dev \
          libqwt6abi1 \
          python-six \
          libgps-dev \
          libgps23 \
          gpsd \
          gpsd-clients \
          python-gps \
          python-setuptools \
          python3-pyqt5 \
          dnsmasq sshfs \
          curl \
          apt-utils \
          python-future \
          libcodec2-dev \
          portaudio19-dev \
          libgsm-tools \
          libgsm1-dev \
          libgmp10 \
          libgmp-dev \
          iputils-ping \
          net-tools \
          putty \
          vim-gnome \
          x11-apps \
          openssh-server \
          python-setuptools \
          && rm -rf /var/lib/apt/lists/*

#------------------------------------------------------------------------------------------
#       Build RFNoC and install Xilinx Vivado
#------------------------------------------------------------------------------------------

#   Set working directory and create folders for env
WORKDIR $INSTALL_BASE

#   Copy E310 Setup Env file
WORKDIR $INSTALL_BASE/rfnoc/e300
COPY    setup.env .

#   Copy build scripts
WORKDIR $INSTALL_BASE
COPY    build_rfnoc-e310.sh .
COPY    Xilinx_Vivado_SDK_2017.4_1216_1.tar.gz .
COPY    vivado_config.txt .
COPY    build_vivado.sh .

#   Create RFNoC Env and Install Xilinx Vivado 
RUN     mkdir -p $INSTALL_BASE/rfnoc \
        && mkdir -p $INSTALL_BASE/rfnoc/oe \
        && mkdir -p $INSTALL_BASE/rfnoc/e300 \
        && mkdir -p $INSTALL_BASE/rfnoc/src \
        && ./build_rfnoc-e310.sh \
        && ./build_vivado.sh

#   Clean up after build, and zip up working directory
WORKDIR $INSTALL_BASE
RUN     tar -zcvf ./rfnoc-e310-volume.tar.gz ./rfnoc \
        && rm -fr ./rfnoc \
        && rm build_rfnoc-e310.sh \
        && rm build_vivado.sh \
        && rm vivado_config.txt

WORKDIR   /
