#!/bin/bash

# -----------------------------------------------------------------------------
# antiX gui for mounting/unmount android devices, by PPC and sybok, 21/5/2020, fully GPL...
# -----------------------------------------------------------------------------

output_a="$HOME/.jmtpfs-output.txt"
output_b="$HOME/.jmtpfs-output3.txt"
dir="$HOME/android_device"
sleep_time=1
yad_title="Android Device USB Connect"
yad_window_icon="phone"
yad_image="/usr/share/icons/papirus-antix/48x48/devices/smartphone.png"

preparation(){
  # Clear some files and prepare directories:
  echo "Clearing files and preparing directories"
  if [ -f "${output_a}" ]; then
    :> "${output_a}"
  fi
  if [ -f "${output_b}" ]; then
    :> "${output_b}"
  fi
  if ! [ -d "${dir}" ]; then
    mkdir -p "$dir"
  fi
} # preparation

check_utilities(){
  # Check that some commands are available
  echo "Check availability of required utilities: started"
  fusermount -V 1>/dev/null || exit 1
  xdg-open --version 1>/dev/null || exit 1
## testing -  yad
	if ! [ -x "$(command -v yad)" ]; then
		echo 'Error: yad is not available' >&2 && exit
	fi
## testing -  jmtpfs
	if ! [ -x "$(command -v jmtpfs)" ]; then
		echo 'Error: jmtpfs is not available' >&2 && exit
	fi
  echo "Check availability of required utilities: finished successfully"
} # check_utilities

check_mounted(){
  # 1- check if a android device seems to be mounted. If so, offer to unmount it and exit OR to access device
	if [ "$(ls -A "$dir")" ]; then
		echo "Android device seems to be mounted"
		yad --fixed --window-icon=$yad_window_icon --image=$yad_image --title "$yad_title" --center --text=$" An android device seems to be mounted. \n \n Choose 'Unmount' to be able to unplug it safely OR \n Choose 'Access device' to view the device's contents again.   "  --button=$"Access device":1 --button=$"Unmount":2
		#--button Unmount && fusermount -u "$dir" && rm -r "$dir" && exit
			foo=$?
			[[ $foo -eq 1 ]] && echo 'user choosed to Access the android device' && desktop-defaults-run -fm "$dir" && exit 1
			[[ $foo -eq 2 ]] && echo 'user choosed to unmount the android device' && fusermount -u "$dir" && rm -r "$dir" ###&& exit
				#### NEW confirmation dialog, that warns if it's safe to unplug the device
				if [ "$(ls -A "$dir")" ]; then
					echo "Android device WAS NOT umounted for some reason, don't unmplug it!!!"
					yad --fixed --window-icon=$yad_window_icon --image=$yad_image --title "$yad_title" --center --text=$" Android device WAS NOT umounted for some reason, don't unmplug it!!!  "  --button=$"OK" && exit
				 else
					echo "Android device is umounted, it's safe unmplug it!!!"
					yad --fixed --window-icon=$yad_window_icon --image=$yad_image --title "$yad_title" --center --text=$" Android device is umounted, it's safe to unmplug it!!!  "  --button=$"OK" && exit
		
				fi
	fi
 } # check_mounted

check_connected(){
  # 2- Check if an android device is connected to the computer, if not, warn user and exit
 while :
	do
		device_check=$(jmtpfs  2>&1)
			if [[ $device_check == *"No mtp"* ]]; then
					echo 'no device connected'
				else echo 'device is connected' && sleep 1 && break
			fi
		yad --fixed --window-icon=$yad_window_icon --image=$yad_image --title "$yad_title" --center --text=$" No (MTP enabled) Android device found! \n  \n Connect a single device using it's USB cable and \n make sure to select it's 'MTP' or 'File share' option and retry.   \n" --button=$"EXIT":1 --button=$"Retry":2
		foo=$?
		[[ $foo -eq 1 ]] && echo 'user pressed Exit' && exit 1
		[[ $foo -eq 2 ]] && echo 'user pressed Retry'
	done
} # check_connected

mount_display(){
  # 3- Try to mount android device and show contents
  jmtpfs "$dir" &&
  
   if  [ "$(ls -A "$dir")" ]; then
	desktop-defaults-run -fm "$dir" ###|& tee -a "${output_b}" 
	echo "device is mounted!"
   else 
	echo "device is NOT mounted!" 
  fi
    echo "just tried to mount device and display it's contents"
} # mount_display

check_while_mount(){
  # 4- When trying to mount device, perform check if device contents are displayed, if not, user may need to allow access on the device. Prompt user to do that and unmount, remount device, and try to display it's contents again
  sleep "${sleep_time}" && echo " Checking if device can be mounted, asking for user to grant permition on the device and retry to mount"
 	if [ "$(ls -A "$dir")" ] ; then
			echo "Device seems properly mounted!"
	     else
			echo "Please check if you have ALLOW access to your files, in your android device,\n in order to procced!" && yad --fixed --window-icon=$yad_window_icon --image=$yad_image --title "$yad_title" --center --text=$"  Please check if you have ALLOW access to your files, in your android device,\n in order to proceed! \n \n Note: if you accidentally did not allow access, unplug then replug your device's USB cable   " --button Retry && fusermount -u "$dir" && jmtpfs "$dir" && desktop-defaults-run -fm "$dir"
	fi
  #recheck if device contents are displayed, if not, warn user and exit and unmount device to avoid errors
  sleep 1 && echo " last check if device can be mounted. If not, unmount it to avoid any errors"
[ "$(ls -A "$dir")" ] && echo "The device seems to be correctly mounted." && exit
 echo "Please check if you have ALLOW access to your files, in your android device,\n in order to procced!" && yad  --fixed --window-icon=$yad_window_icon --image=$yad_image --title "$yad_title" --center --text=$"  Unable to mount device! \n Please check it you correctly selected, in your device, the 'MTP...' or 'File transfer...' options.   \n Or 'Allowed' file access. \n \n Unplug and replug your device and try again..." --button Exit
	 fusermount -u "$dir" && rm -r "$dir"
} # check_while_mount

main(){
  # The main function
  preparation
  check_utilities
  check_mounted
  check_connected
  mount_display
  check_while_mount
  echo "Done"
} # main

main
