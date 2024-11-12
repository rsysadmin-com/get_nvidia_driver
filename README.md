# get_nvidia_driver
Linux nVidia Driver Downloader and Installer

## Usage

```
$ ./get_nvidia_driver.sh -h
Usage: get_nvidia_driver.sh [-h] [-d [version]] [-i [version]] [-l [n]] [-c]
Options:
    -h                  Prints this help
    -d [version]        Download only; specify version optionally (e.g., 565.57.01)
    -i [version]        Download and install; specify version optionally (requires root)
    -l [n]              List the last n versions available; defaults to last 5 if n is not specified
    -c                  Check latest stable version only
```
For the `-i` option, it is advised to run this script as `root` from `runlevel 3`.

Both `-d` and `-i` options now accept an optional version argument.

If no version is specified, the script will default to downloading the version listed in `latest.txt`. If a version is provided, the script will download that specific version.

Examples:

- Download the latest version (from `latest.txt`):

    `./get_nvidia_driver.sh -d`

    This will download version `550.127.05` (the latest stable version as of this writing).

- Download a specific version:

    `./get_nvidia_driver.sh -d 565.57.01`

    This will download version `565.57.01`.

- List the last versions available (oldest -> newest)

    .`/get_nvidia_driver.sh -l`

    This will show the last 5 available versions (default option)

    `./get_nvidia_driver.sh -l 3`

    This will show the last 3 available versions


## Dependencies
`get_nvidia_driver.sh` needs `wget` to download the files and `lynx` to list the remote contents of `$nvidia_url`.<p>
If they are not installed, the script will complain with an error and quit.<p>

## A word of advice based on personal experiences
This script relies on a file called `latest.txt` provided by nVidia, so a lot of trust is put on them to keept its contents current.<p>
With that being said, if the contents of `latest.txt` are garbled, the script may retrieve the wrong drivers or not work at all. So if you see something suspicious, please check manually by visiting https://download.nvidia.com/XFree86/Linux-x86_64 from your web browser<p>
For example: if your current driver belongs to the `5xx.xx` series and the script downloads something from the `3xx.xx` range, something is usually wrong.<p>

### Disclaimer: 
This script is provided on an "AS IS" basis.<p>
The autor is not to held responsible for the use, misuse and/or any damage that this little tool may cause.<p>
