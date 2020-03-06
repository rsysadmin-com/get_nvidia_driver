# get_nvidia_driver
<p>
Linux nVidia Driver Downloader<br>
by martin@mielke.com<br>
==============================<br>
<br>
get_nvidia_driver.sh [-h][-d][-i]<br>
-h Prints this help<br>
-d Download only <br>
-i (root only) Download and install<br>
-c Check latest only (no download, no install)
<hr>
For the -i option, it is advised to run this as root on runlevel 3.<br>
<br>

## Dependencies
get_nvidia_driver.sh needs wget for the file downloads.<p>
If it is not installed, the script will complain with an error and quit.<p>

## A word of advice based on personal experiences
This script relies on a file called latest.txt so a lot of trust is put on nVidia to keept its contents current.<p>
With that being said, if the contents of latest.txt are garbled, the script may retrieve the wrong drivers or not work at all. So if you see something suspicious, please check manually.<p>
For example: if your current driver belongs to the 4xx.xx series and the script downloads a 3xx.xx, something is usually wrong.<p>

### Disclaimer: 
This script is provided on an "AS IS" basis.<p>
The autor is not to held responsible for the use, misuse and/or any damage that this little tool may cause.<p>
