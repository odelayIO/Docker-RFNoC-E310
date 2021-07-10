xhost local:root

# Could add the following with your IP address
#  -e DISPLAY='XXX.XXX.XXX.XXX:XX' \

docker run -it --rm \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /home/sdr/workspace/rfnoc-e310/rfnoc-shared:/home/sdr/rfnoc-shared \
  rfnoc-e310:v0.1 \
  /bin/bash
