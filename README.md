

# Introduction

This Docker file creates a container for RFNoC development with Xilinx HLS targeting the Ettus Research E310 SDR.  This was built on Ubuntu 18.04 OS.  The Xilinx Vivado 17.04 tool will need to be downloaded and copied to the same folder location as the Docker file. This is based on the following documentation by Ettus Research [LINK](https://kb.ettus.com/Software_Development_on_the_E3xx_USRP_-_Building_RFNoC_UHD_/_GNU_Radio_/_gr-ettus_from_Source). 



Building the Docker Container

```bash
sudo docker build -t rfnoc-e310:v0.1 ./
```

Running the container

```bash
./run_rfnoc-e310.sh
```

During the building of the environment, the home folder /home/sdr was created.  To begin development, the rfnoc-e310-volume.tar.gz file will need to be extracted into the shared folder.  This is the source code required to be developing custom RFNoC blocks targeting the E310.

After starting the container run the following:

```shell
cd /home/sdr
tar -zxvf rfnoc-e310-volume.tar.gz -C /home/sdr/rfnoc-shared/rfnoc
```



# File Description

| File                | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| Dockerfile          | The Docker script to build the RFNoC development environment. |
| build_rfnoc-e310.sh | Commands for building RFNoC environment, along with the E310 cross-compiled version of the tools. |
| build_vivado.sh     | Commands for installing Xilinx Vivado.  This will require Xilinx_Vivado_SDK_2017.4_1216_1.tar.gz file to be located in the same directory as Dockerfile. |
| vivado_config.txt   | Install settings for Xilinx Vivado                           |
| setup.env           | The setup environment script for the E310 after coping the clear build of RFNoC tools |
| run_rfnoc-e310.sh   | Docker container startup script.  This creates a shared folder named "rfnoc-shared" where all the source code is located. |



# Required Downloads

#### Download Ubuntu 18.04 ISO Image

http://old-releases.ubuntu.com/releases/18.04.4/ubuntu-18.04-desktop-amd64.iso



#### Download Xilinx Vivado 17.04

Requires login to download file

https://www.xilinx.com/member/forms/download/xef-vivado.html?filename=Xilinx_Vivado_SDK_2017.4_1216_1.tar.gz

Then copy in base folder location where the `Dockerfile` is located.



# Resources

#### **RFNoC**

https://kb.ettus.com/RFNoC

https://kb.ettus.com/Getting_Started_with_RFNoC_Development

https://www.gnuradio.org/grcon/grcon20/grcon20_RFNoC_4_Part1.pdf

https://www.gnuradio.org/grcon/grcon20/grcon20_RFNoC_4_Part2.pdf

https://files.ettus.com/app_notes/RFNoC_Specification.pdf

https://kb.ettus.com/Streaming_processed_data_from_the_E31x_with_GNU_Radio_and_ZMQ

https://kb.ettus.com/Getting_Started_with_RFNoC_Development#Starting_a_custom_RFNoC_block_using_RFNoC_Modtool

https://kb.ettus.com/images/1/1e/RFNoC_Wireless_at_VirginiaTech_2014_Host.pdf

https://static1.squarespace.com/static/543ae9afe4b0c3b808d72acd/t/55f85bc2e4b067b8c2af4eaf/1442339778410/3-pendlum_jonathon-rfnoc_tutorial_fpga.pdf



#### **E310 Information**

https://kb.ettus.com/E310/E312

https://files.ettus.com/manual/md_usrp3_build_instructions.html

https://www.xilinx.com/products/silicon-devices/soc/zynq-7000.html#productTable



#### **Ubuntu Setup**

https://help.ubuntu.com/community/SSH/OpenSSH/Configuring

https://github.com/EttusResearch/ettus-pybombs

