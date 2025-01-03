#!/bin/bash

source /opt/edgeai-gst-apps/scripts/setup_camera_ox05b.sh


## RGB+IR pipeline w/ telemetery/video-encode on RGB and deep learning on IR (DMS@30fps, OMS@5fps)
#### Main pipeline for the app note's app-3 section
GST_DEBUG_FILE=/run/trace.log GST_DEBUG_NO_COLOR=1 GST_DEBUG="GST_TRACER:7" GST_TRACERS="latency(flags=element)" \
gst-launch-1.0  -v -e \
v4l2src device=/dev/video3 io-mode=dmabuf-import ! \
video/x-bayer, width=2592, height=1944, framerate=30/1, format=bggi10 !   \
tiovxisp name=isp_ir sink_0::pool-size=2 src_0::pool-size=2 sensor-name="SENSOR_OX05B1S" \
dcc-isp-file=/opt/imaging/ox05b1s/linear/dcc_viss.bin sink_0::dcc-2a-file=/opt/imaging/ox05b1s/linear/dcc_2a.bin format-msb=9 ! \
video/x-raw, format=GRAY8, width=2592, height=1944 ! queue name=ir_out max-size-buffers=2 leaky=2 ! \
tiovxmultiscaler target=1 name=ir_scaler \
ir_scaler. !  video/x-raw, width=648, height=512, format=GRAY8 ! queue  max-size-buffers=2 leaky=2 !  tiovxdlcolorconvert ! \
video/x-raw, format=NV12 ! tiovxmultiscaler target=1 name=dl_scaler  \
dl_scaler. ! video/x-raw, width=416, height=416 ! queue max-size-buffers=2 leaky=2 ! \
tiovxdlpreproc model=/opt/model_zoo/ONR-OD-8200-yolox-nano-lite-mmdet-coco-416x416  out-pool-size=4 name=DMS_preproc ! \
application/x-tensor-tiovx  ! tidlinferer target=1  model=/opt/model_zoo/ONR-OD-8200-yolox-nano-lite-mmdet-coco-416x416 name=DMS_DL ! \
fpsdisplaysink fps-update-interval=5000  video-sink="fakesink async=false" text-overlay=false sync=false name=DMS_OUT \
dl_scaler. ! video/x-raw, width=512, height=512 ! \
videorate drop-only=true max-rate=5 !  video/x-raw,framerate=5/1 ! \
queue name=OMS_q max-size-buffers=2 leaky=2 ! \
tiovxdlpreproc model=/opt/model_zoo/ONR-SS-8610-deeplabv3lite-mobv2-ade20k32-512x512  out-pool-size=4 name=OMS_preproc ! \
application/x-tensor-tiovx ! \
tidlinferer target=1  model=/opt/model_zoo/ONR-SS-8610-deeplabv3lite-mobv2-ade20k32-512x512 name=OMS_DL ! \
fpsdisplaysink fps-update-interval=5000  video-sink="fakesink async=false" text-overlay=false sync=false name=OMS_out \
\
v4l2src device=/dev/video4 io-mode=dmabuf-import ! \
video/x-bayer, width=2592, height=1944, framerate=30/1, format=bggi10 !  \
tiovxisp name=isp_rgb sink_0::pool-size=2 sink_0::device=/dev/v4l-subdev2 sensor-name="SENSOR_OX05B1S" \
dcc-isp-file=/opt/imaging/ox05b1s/linear/dcc_viss.bin sink_0::dcc-2a-file=/opt/imaging/ox05b1s/linear/dcc_2a.bin format-msb=9 ! \
video/x-raw, format=NV12, width=2592, height=1944 ! queue max-size-buffers=2 leaky=2 name=RGB_Q !  \
tiovxldc dcc-file=/opt/imaging/ox05b1s/linear/dcc_ldc.bin sensor-name=SENSOR_OX05B1S sink_0::pool-size=2 src::pool-size=2 ! \
queue max-size-buffers=2 leaky=2 name=RGB_scaler_Q ! tiovxmultiscaler target=0 ! video/x-raw,width=1920,height=1080 ! \
v4l2h264enc extra-controls="controls, frame_level_rate_control_enable=1, video_bitrate=10000000, video_gop_size=30" !  \
filesink location=/opt/edgeai-test-data/output/output_video.h264 


## RGB+IR pipeline w/ telemetery/video-encode on RGB and deep learning on IR (DMS@30fps, OMS@5fps)
#### Main pipeline for the app note's app-3 section; 
#### v2 with num_buffers=600

# GST_DEBUG_FILE=/run/trace.log GST_DEBUG_NO_COLOR=1 GST_DEBUG="GST_TRACER:7" GST_TRACERS="latency(flags=element)" \
# gst-launch-1.0  -v -e \
# v4l2src device=/dev/video3 io-mode=dmabuf-import num-buffers=600 ! \
# video/x-bayer, width=2592, height=1944, framerate=30/1, format=bggi10 !   \
# tiovxisp name=isp_ir sink_0::pool-size=2 src_0::pool-size=2 sensor-name="SENSOR_OX05B1S" \
# dcc-isp-file=/opt/imaging/ox05b1s/linear/dcc_viss.bin sink_0::dcc-2a-file=/opt/imaging/ox05b1s/linear/dcc_2a.bin format-msb=9 ! \
# video/x-raw, format=GRAY8, width=2592, height=1944 ! queue name=ir_out max-size-buffers=2 leaky=2 ! \
# tiovxmultiscaler target=1 name=ir_scaler \
# ir_scaler. !  video/x-raw, width=648, height=512, format=GRAY8 ! queue  max-size-buffers=2 leaky=2 !  tiovxdlcolorconvert ! \
# video/x-raw, format=NV12 ! tiovxmultiscaler target=1 name=dl_scaler  \
# dl_scaler. ! video/x-raw, width=416, height=416 ! queue max-size-buffers=2 leaky=2 ! \
# tiovxdlpreproc model=/opt/model_zoo/ONR-OD-8200-yolox-nano-lite-mmdet-coco-416x416  out-pool-size=4 name=DMS_preproc ! \
# application/x-tensor-tiovx  ! tidlinferer target=1  model=/opt/model_zoo/ONR-OD-8200-yolox-nano-lite-mmdet-coco-416x416 name=DMS_DL ! \
# fpsdisplaysink fps-update-interval=5000  video-sink="fakesink async=false" text-overlay=false sync=false name=DMS_OUT \
# dl_scaler. ! video/x-raw, width=512, height=512 ! \
# videorate drop-only=true max-rate=5 !  video/x-raw,framerate=5/1 ! \
# queue name=OMS_q max-size-buffers=2 leaky=2 ! \
# tiovxdlpreproc model=/opt/model_zoo/ONR-SS-8610-deeplabv3lite-mobv2-ade20k32-512x512  out-pool-size=4 name=OMS_preproc ! \
# application/x-tensor-tiovx ! \
# tidlinferer target=1  model=/opt/model_zoo/ONR-SS-8610-deeplabv3lite-mobv2-ade20k32-512x512 name=OMS_DL ! \
# fpsdisplaysink fps-update-interval=5000  video-sink="fakesink async=false" text-overlay=false sync=false name=OMS_out \
# \
# v4l2src device=/dev/video4 io-mode=dmabuf-import num-buffers=600 ! \
# video/x-bayer, width=2592, height=1944, framerate=30/1, format=bggi10 !  \
# tiovxisp name=isp_rgb sink_0::pool-size=2 sink_0::device=/dev/v4l-subdev2 sensor-name="SENSOR_OX05B1S" \
# dcc-isp-file=/opt/imaging/ox05b1s/linear/dcc_viss.bin sink_0::dcc-2a-file=/opt/imaging/ox05b1s/linear/dcc_2a.bin format-msb=9 ! \
# video/x-raw, format=NV12, width=2592, height=1944 ! queue max-size-buffers=2 leaky=2 name=RGB_Q !  \
# tiovxldc dcc-file=/opt/imaging/ox05b1s/linear/dcc_ldc.bin sensor-name=SENSOR_OX05B1S sink_0::pool-size=2 src::pool-size=2 ! \
# queue max-size-buffers=2 leaky=2 name=RGB_scaler_Q ! tiovxmultiscaler target=0 ! video/x-raw,width=1920,height=1080 ! \
# v4l2h264enc extra-controls="controls, frame_level_rate_control_enable=1, video_bitrate=10000000, video_gop_size=30" !  \
# filesink location=/opt/edgeai-test-data/output/output_video.h264 
