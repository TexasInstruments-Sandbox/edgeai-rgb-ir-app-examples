#!/bin/bash

source /opt/edgeai-gst-apps/scripts/setup_camera_ox05b.sh


## RGB only pipeline: streaming from camera to a display
#### Main pipeline for the app note's Application 1 section
GST_DEBUG_FILE=/run/trace.log GST_DEBUG_NO_COLOR=1 GST_DEBUG="GST_TRACER:7" GST_TRACERS="latency(flags=element)" \
gst-launch-1.0 -v \
v4l2src device=/dev/video4 io-mode=dmabuf-import ! \
video/x-bayer, width=2592, height=1944, framerate=30/1, format=bggi10 ! queue ! \
tiovxisp sink_0::pool-size=2 sink_0::device=/dev/v4l-subdev2 sensor-name="SENSOR_OX05B1S" \
dcc-isp-file=/opt/imaging/ox05b1s/linear/dcc_viss.bin sink_0::dcc-2a-file=/opt/imaging/ox05b1s/linear/dcc_2a.bin format-msb=9 ! \
queue ! tiovxldc dcc-file=/opt/imaging/ox05b1s/linear/dcc_ldc.bin sensor-name=SENSOR_OX05B1S sink_0::pool-size=3 src::pool-size=3 ! \
video/x-raw, format=NV12, width=2592, height=1944 ! queue ! \
tiovxmultiscaler src_0::pool-size=3 target=1 ! video/x-raw, format=NV12, width=1920, height=1080 ! queue ! \
tiperfoverlay ! queue ! \
fpsdisplaysink fps-update-interval=5000 name=RGB video-sink="kmssink driver-name=tidss force-modesetting=true sync=false" text-overlay=false sync=false

