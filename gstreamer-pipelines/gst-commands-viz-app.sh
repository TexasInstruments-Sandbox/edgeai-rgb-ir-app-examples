#!/bin/bash

source /opt/edgeai-gst-apps/scripts/setup_camera_ox05b.sh


GST_DEBUG_FILE=/run/trace.log GST_DEBUG_NO_COLOR=1 GST_DEBUG="GST_TRACER:7" GST_TRACERS="latency(flags=element)" \
gst-launch-1.0  -v \
v4l2src device=/dev/video4 io-mode=dmabuf-import name=rgb_src ! \
video/x-bayer, width=2592, height=1944, framerate=30/1, format=bggi10 !  \
tiovxisp name=rgb_isp sink_0::pool-size=2 sink_0::device=/dev/v4l-subdev2 sensor-name="SENSOR_OX05B1S" \
dcc-isp-file=/opt/imaging/ox05b1s/linear/dcc_viss.bin sink_0::dcc-2a-file=/opt/imaging/ox05b1s/linear/dcc_2a.bin format-msb=9 ! \
video/x-raw, format=NV12, width=2592, height=1944 ! queue !  tiovxmultiscaler target=0 name=rgb_scaler ! video/x-raw,width=960,height=540 ! queue  ! mosaic. \
v4l2src device=/dev/video3 io-mode=dmabuf-import name=ir_src ! \
video/x-bayer, width=2592, height=1944, framerate=30/1, format=bggi10 !   \
tiovxisp name=ir_isp sink_0::pool-size=2 src_0::pool-size=2 sensor-name="SENSOR_OX05B1S" \
dcc-isp-file=/opt/imaging/ox05b1s/linear/dcc_viss.bin sink_0::dcc-2a-file=/opt/imaging/ox05b1s/linear/dcc_2a.bin format-msb=9 ! \
 video/x-raw, format=GRAY8, width=2592, height=1944 ! queue ! tiovxmultiscaler target=1 name=ir_scaler  ! \
video/x-raw,width=960,height=540 !  tiovxdlcolorconvert name=ir_cvt ! queue  ! mosaic. \
tiovxmosaic name=mosaic target=0 sink_0::startx="<0>" sink_0::starty="<120>" sink_0::heights="<540>" sink_0::widths="<960>"  sink_1::startx="<960>" sink_1::starty="<120>" sink_1::heights="<540>" sink_1::widths="<960>" ! \
video/x-raw,height=1080,width=1920,framerate=30/1 ! \
fpsdisplaysink fps-update-interval=5000 name=display video-sink="kmssink driver-name=tidss force-modesetting=true sync=false" text-overlay=false sync=false 


## limited number of buffers

# GST_DEBUG_FILE=/run/trace.log GST_DEBUG_NO_COLOR=1 GST_DEBUG="GST_TRACER:7" GST_TRACERS="latency(flags=element)" \
# gst-launch-1.0  -v \
# v4l2src device=/dev/video4 io-mode=dmabuf-import num-buffers=600 ! \
# video/x-bayer, width=2592, height=1944, framerate=30/1, format=bggi10 !  \
# tiovxisp name=isp_rgb sink_0::pool-size=2 sink_0::device=/dev/v4l-subdev2 sensor-name="SENSOR_OX05B1S" \
# dcc-isp-file=/opt/imaging/ox05b1s/linear/dcc_viss.bin sink_0::dcc-2a-file=/opt/imaging/ox05b1s/linear/dcc_2a.bin format-msb=9 ! \
# video/x-raw, format=NV12, width=2592, height=1944 ! queue !  tiovxmultiscaler target=0 ! video/x-raw,width=960,height=540 ! queue  ! mosaic. \
# v4l2src device=/dev/video3 io-mode=dmabuf-import num-buffers=600 ! \
# video/x-bayer, width=2592, height=1944, framerate=30/1, format=bggi10 !   \
# tiovxisp name=isp_ir sink_0::pool-size=2 src_0::pool-size=2 sensor-name="SENSOR_OX05B1S" \
# dcc-isp-file=/opt/imaging/ox05b1s/linear/dcc_viss.bin sink_0::dcc-2a-file=/opt/imaging/ox05b1s/linear/dcc_2a.bin format-msb=9 ! \
#  video/x-raw, format=GRAY8, width=2592, height=1944 ! queue ! tiovxmultiscaler target=1  ! \
# video/x-raw,width=960,height=540 !  tiovxdlcolorconvert ! queue  ! mosaic. \
# tiovxmosaic name=mosaic  sink_0::startx="<0>" sink_0::starty="<120>" sink_0::heights="<540>" sink_0::widths="<960>"  sink_1::startx="<960>" sink_1::starty="<120>" sink_1::heights="<540>" sink_1::widths="<960>" ! \
# video/x-raw,height=1080,width=1920,framerate=30/1 ! \
# fpsdisplaysink fps-update-interval=5000 name=rgb video-sink="kmssink driver-name=tidss force-modesetting=true sync=false" text-overlay=false sync=false 


