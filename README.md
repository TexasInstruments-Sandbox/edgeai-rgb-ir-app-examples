# Edge AI RGB-IR Application Examples

This repo holds several examples for RGB-Infrared camera usage on Edge AI SoC AM62A. Please note this repository is a Work in Progress

The main camera used in these applications is a 5 MP global shutter RGB-Ir sensor, OX05B1S from Omnivision.

These applications are provided in accordance with an application note (link TBD). The applications include:
* Dual visualization of RGB and Infrared streams on the same display with Gstreamer
* Dual visualization of RGB and Infrared streams on the same display with TIOVX (build to be 1:1 with gstreamer for comparing performance)
* DMS+OMS+Video Telephony representative application built with Gstreamer. 
    * Driver monitoring and Occupancy monitoring are emulated with a face-detection and segmentation AI model (respectively) on the Ir stream, and video telephony runs on the RGB stream to encode and save compressed frames to a local file