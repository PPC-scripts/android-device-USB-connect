# android-device-USB-connect

GUI script to easily mount and access MTP enabled android devices file system from Linux

21/5/2020

I didn't find a single short and direct GUI way that allowed me to simply access my android device from my (antiX Linux) desktop computer. I had a short script, that just ran jmtpfs to mount my device, but that failed to work with my newer Android 10 device, so I improved the script... one thing led to another and Android device USB connect was born.

I thank the effort of antiX forum user Sybok, that helped shape the script into something that made it look like it was coded by someone that knew what he was doing...

- What this script does:

    - run the script once - if an android device is connected to your linux OS, it's file system is automaticaly mounted and it's contents displayed in the default file manager.
            If no device is detected a small window pops up and tells the user how to connect a device to the computer.
            If there's any further need for user to allow access to the device, a new warning pops up, asking the user to do that, then conties to try to mount the device.
    - run the script again - a window, telling the user that an android device is already mounted, asks if the device is to be accessed (then the default file manager displays it's contents) or to be unmounted.
 
 * Dependencies:
  jmtpfs, fusermount ,  yad and xdg-open
  
 * Notes:
  This script was writen using antiX 19, and tested on that OS only. It should work on any Linux OS that has all the dependencies installed...
  
  
 
 
