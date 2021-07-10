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
#   Description : Build script for Xilinx Vivado 2017.4
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
#
#
#
#############################################################################################
#############################################################################################





INSTALL_BASE=/home/sdr

cd $INSTALL_BASE

tar -zxvf Xilinx_Vivado_SDK_2017.4_1216_1.tar.gz

./Xilinx_Vivado_SDK_2017.4_1216_1/xsetup \
  --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
  --batch Install \
  --config ./vivado_config.txt

rm -rf ./Xilinx_Vivado_SDK_2017.4_1216_1
rm -rf ./Xilinx_Vivado_SDK_2017.4_1216_1.tar.gz



