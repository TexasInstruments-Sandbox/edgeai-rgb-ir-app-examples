The TIOVX pipeline here is run as a test and corresponds an [equivalent pipeline in gstreamer](../gstreamer-pipelines/gst-commands-viz-app.sh)

To run the example here, apply the following steps

1) Within the SDK, navigate to /opt/edgeai-tiovx-apps
  * Optionally, clone from [upstream](https://github.com/TexasInstruments/edgeai-tiovx-apps/)
2) Apply the patch [0001-rgbir-gst-comp-test.patch](../0001-rgbir-gst-comp-test.patch)
  * ```git apply 0001-rgbir-gst-comp-test.patch```
  * Alternatively within edgeai-tiovx-apps/tests, add the .C file in this folder, add to CMakeLists.txt, and edit main.c. Main.c would then be changed to add another test case that calls the pseudo-main function within [app_tiovx_linux_rgb_ir_capture_display_test_TIOVXvsGST.c](./app_tiovx_linux_rgb_ir_capture_display_test_TIOVXvsGST.c)
3) Build the edgeai-tiovx-apps project using the directions in the corresponding readme
4) Call edgeai-tiovx-apps/bin/Release/edgeai-tiovx-apps-test
  * The tests are run sequentially, and are enabled with #defines in tests/main.c. It is recommended to have all off (0), except for the test of interest.  