# get_nvidia_driver
Linux nVidia Driver Downloader and Installer

## Usage

```
get_nvidia_driver.sh [-h][-d][-i]
-h Prints this help
-d Download only 
-i (root only) Download and install
-c Check latest only (no download, no install)
```
For the `-i` option, it is advised to run this script as `root` from `runlevel 3`.


## Dependencies
`get_nvidia_driver.sh` needs `wget` to download the files.<p>
If it is not installed, the script will complain with an error and quit.<p>

## A word of advice based on personal experiences
This script relies on a file called `latest.txt` provided by nVidia, so a lot of trust is put on them to keept its contents current.<p>
With that being said, if the contents of `latest.txt` are garbled, the script may retrieve the wrong drivers or not work at all. So if you see something suspicious, please check manually by visiting https://download.nvidia.com/XFree86/Linux-x86_64 from your web browser<p>
For example: if your current driver belongs to the `5xx.xx` series and the script downloads something from the `3xx.xx` range, something is usually wrong.<p>

### Disclaimer: 
This script is provided on an "AS IS" basis.<p>
The autor is not to held responsible for the use, misuse and/or any damage that this little tool may cause.<p>
