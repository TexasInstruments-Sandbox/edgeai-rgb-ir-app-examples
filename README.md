# Edge AI RGB-IR Application Examples

This repo holds several examples for RGB-Infrared camera usage on Edge AI SoC AM62A. 

The main camera used in these applications is a 5 MP global shutter RGB-Ir sensor, OX05B1S from Omnivision. For these applications, we use a camera module from Leopard imaging:
    * [Leopard Imaging LI-OX05B1S-MIPI-137H](https://www.leopardimaging.com/product/csi-2-mipi-modules-i-pex/csi-2-mipi-modules/global-shutter-mipi-cameras/5mp-ox05b1s/li-ox05b1s-mipi-137h)
    * Additional cables needed: [FAW-1233-03](https://www.leopardimaging.com/product/accessories/cables/faw-1233-03/) and [LI-FPC22-IPEX-PI](https://www.leopardimaging.com/product/nvidia-jetson-cameras/nvidia-jetson-orin-nx-camera-kit/li-fpc22-ipex-pi/).

These applications are provided in accordance with an [application note](https://www.ti.com/lit/pdf/spradp7). The applications include:
* Gstreamer pipelines under [gstreamer-pipelines](./gstreamer-pipelines/):
    * Visualization of RGB stream on a display with Gstreamer
    * Dual visualization of RGB and Infrared streams on the same display with Gstreamer
    * DMS+OMS+Video Telephony representative application built with Gstreamer. 
        * Driver monitoring and Occupancy monitoring are emulated with a face-detection and segmentation AI model (respectively) on the Ir stream, and video telephony runs on the RGB stream to encode and save compressed frames to a local file
* TI OpenVX pipeline based on [edgeai-tiovx-apps](https://github.com/TexasInstruments/edgeai-tiovx-apps) under [tiovx-pipeline](./tiovx-pipeline/)
    * Dual visualization of RGB and Infrared streams on the same display with TIOVX (build to be 1:1 with gstreamer for comparing performance)
    * Tested against SDK 10.0 and 10.1 versions. Please use version within those SDK's or from version tags 10.00.00.08 or 10.01.00.06 for the respective SDKs. Versions beyond 10.1.x may not cleanly apply the patch

Please note that before running any of these applications with camera OX05B1S, it is required to apply a device tree overlay and run several media-ctl and v4l2-ctl commands. 
* Apply DTBO:
    * in the boot partition's uEnv.txt, add the ox05b1s module to the names_overlay, like so:
        * name_overlays=ti/k3-am62a7-sk-csi2-ox05b1s.dtbo
        * This DTBO file exists on the targetfs partition under /boot/dtb
* Setup commands:
    * Please refer to [setup_camera_ox05b.sh in edgeai-gst-apps](https://github.com/TexasInstruments/edgeai-gst-apps/blob/EDGEAI_APP_STACK_10_01_00_00/scripts/setup_camera_ox05b.sh) for OX05B module setup commands


App note available on TI.com: https://www.ti.com/lit/pdf/spradp7 
