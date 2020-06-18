#!/bin/bash
# Rclone remote drive mounter script v0.1 
# choose a remote using yad
  rclone listremotes > /tmp/rclone_remote_list.txt
 selection=$(yad --title="Choose Cloud service to mount with Rclone" --width=550 --height=400 --center --separator=" " --list  --column="Configured Cloud services" --button=gtk-ok:0 --button="Unmount Cloud Drives":1 --button=gtk-quit:2 < /tmp/rclone_remote_list.txt)
 foo=$?
[[ $foo -eq 2 ]] && exit 0
if [[ $foo -eq 1 ]]; then
pkill rclone && exit 0
fi

# create a mount point using the same name:
mount_point=$(echo $selection | sed 's/.$//')
mount_point_no_spaces=$(echo $mount_point | sed -e 's/ //g')
mkdir ~/$mount_point_no_spaces
 # mount the cloud service
 #### nohup rclone --vfs-cache-mode writes mount  xxxx: ~/yyyy &
 #   rclone --vfs-cache-mode writes mount  $selection ~/$mount_point_no_spaces
# run=$(echo rclone --vfs-cache-mode writes mount  $selection ~/$mount_point_no_spaces)
comma="'"
myVar=$(echo "rclone --vfs-cache-mode writes mount "${comma}""${selection}"${comma}")
echo $myVar
myVar2=`echo $myVar | sed -E 's/.(.)$/\1/'`
echo $myVar2
echo  $myVar2 ~/$mount_point_no_spaces
eval "nohup  $myVar2 ~/$mount_point_no_spaces &"

##Original command, that does not support spaces in the "remote" name
#run=$(echo nohup rclone --vfs-cache-mode writes mount $selection ~/$mount_point_no_spaces)
#echo $run

 #show the cloud service contents on the default file manager: #for other distros other than antiX, that have xdg-open installed
 ##xdg-open "~\$mount_point_no_spaces"  
desktop-defaults-run -fm ~/$mount_point_no_spaces
