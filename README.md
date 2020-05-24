# android-device-USB-connect

GUI script to easily mount and access MTP enabled android devices file system from Linux

21/5/2020

I didn't find a single short and direct GUI way that allowed me to simply access my android device from my (antiX Linux) desktop computer. I had a short script, that just ran jmtpfs to mount my device, but that failed to work with my newer Android 10 device, so I improved the script... one thing led to another and Android device USB connect was born.

I thank the effort of antiX forum user Sybok, that helped shape the script into something that made it look like it was coded by someone that knew what he was doing...

- **How to use this script:**

    - **run the script once - if an android device is connected to your linux OS, it's file system is automaticaly mounted and it's contents displayed in the default file manager.**
            - If no device is detected a small window pops up and tells the user how to connect a device to the computer.
            - If there's any further need for user to allow access to the device, a new warning pops up, asking the user to do that, then conties to try to mount the device.
    - **run the script again - a window, telling the user that an android device is already mounted, asks if the device is to be accessed (then the default file manager displays it's contents) or to be unmounted**. If user chooses to unmount, a final warning informs if it's safe to unplug the device.
 
 * Dependencies:
  jmtpfs, fusermount ,  yad and xdg-open (for the general version) / destop-defaults (for the antiX version)
  
 * Notes:
  This script was writen using antiX 19, and tested on that OS only. It should work on any Linux OS that has all the dependencies installed...
  
  I currently offer 2 version of the script: the original one, that should be compatible with any Linux distro, and a "antiX only" version, that accesses the devices contents using this OS default File Manager.
  
  * Tip: For antiX linux users (with the default Icewm desktop) that want to an icon for this script available in the toolbar:
   1- save the script.
   2- antiX Menu- Control Centre - Edit Icewm... - Toolbar tab
   3- Add a line with this contents (using the correct full path to your script):
        
    prog "Android Device USB Connect" /usr/share/icons/papirus-antix/24x24/devices/phone.png [path/to/script]
    
    Save the changes and restart Icewm (antiX Menu - Logout arrow- Restart Icewm)
  
  
  
 
 
