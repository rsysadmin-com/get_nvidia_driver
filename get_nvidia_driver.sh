#!/bin/bash

#
# get_nvidia_driver.sh
# by martinm@rsysadmin.com
#
# quick and dirty script to fetch nVidia's latest driver for Linux.
#
# ./get_nvidia_driver.sh -h for help
#
# Disclaimer: this script is provided on an "AS IS" basis.
# The autor is not to held responsible for the use, misuse and/or any damage
# that this little tool may cause.
#

# Variables
nvidia_url="https://download.nvidia.com/XFree86/Linux-x86_64"
nvidia_latest="$nvidia_url/latest.txt"
target_dir=$(pwd)
version=""

# Functions
function banner() {
    cat <<BANNER
Linux nVidia Driver Downloader and Installer

by martinm@rsysadmin.com
============================================

BANNER
}

function goodbye() {
    echo -e "--> Doing some clean up..."
    rm -f latest.txt
    echo -e "\n=== All set.\n"
    exit 0
}

function usage() {
    cat << EOF
Usage: $(basename $0) [-h] [-d [version]] [-i [version]] [-c]
Options:
    -h                  Prints this help
    -d [version]        Download only; specify version optionally (e.g., 565.57.01)
    -i [version]        Download and install; specify version optionally (requires root)
    -c                  Check latest stable version only
EOF
}

function returnStatus() {
    [[ $? -eq 0 ]] && echo -e "[ PASS ]" || echo -e "[ FAIL ]"
}

function get_latest() {
    echo -e "--> Fetching latest stable nVidia driver version... \c"
    wget -q "$nvidia_latest" -O latest.txt
    returnStatus
    nvidia_driver_version=$(awk '{ print $1 }' latest.txt)
    nvidia_driver_file=$(awk '{ print $2 }' latest.txt | awk -F/ '{ print $2 }')
    echo "--> Latest stable version available on nVidia's website: $nvidia_driver_version"
}

function download_file() {
    local driver_version="${version:-$nvidia_driver_version}"  # Use specified version or fallback to latest
    local file="NVIDIA-Linux-x86_64-$driver_version.run"
    
    if [ -r "$target_dir/$file" ]; then
        echo "--> Found local copy of $file ..."
        ls -l "$target_dir/$file"
    else
        echo -e "--> Downloading nVidia driver version $driver_version...\n"
        wget -q "$nvidia_url/$driver_version/$file" -O "$target_dir/$file"
        chmod +x "$target_dir/$file"
        echo "--> Downloaded and set execution permissions for $file"
        ls -l "$target_dir/$file"
    fi
}

function download_only() {
    download_file
}

function download_install() {
    download_file
    echo -e "\n= Following steps to install:\n"
    echo -e "\t1) Switch to runlevel 3"
    echo -e "\t2) Run the installer\n"
    echo -e "--> Commands:"
    echo -e "\n\tinit 3"
    echo -e "\n\t$target_dir/NVIDIA-Linux-x86_64-$version.run -Xq\n"
    echo "--> Reboot after installation."
}

function ru_root() {
    if [[ $UID -ne 0 ]]; then
        echo -e "WARNING - You need to be root to install."
        exit 3
    fi
}

# Main
mode=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h) usage; exit 0;;
        -d)
            mode="download"
            # Check if the next argument is a version number (i.e., matches n.n.n pattern)
            if [[ $2 =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                version="$2"
                shift
            fi
            ;;
        -i)
            mode="install"
            if [[ $2 =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                version="$2"
                shift
            fi
            ;;
        -c) mode="check";;
        *) usage; exit 1;;
    esac
    shift
done

banner

# Fetch the latest version if no version is specified and mode is not "check"
if [[ -z "$version" && "$mode" != "check" ]]; then
    get_latest
    version="$nvidia_driver_version"
fi

# Execute based on mode
case $mode in
    "download") download_only ;;
    "install") ru_root; download_install ;;
    "check") get_latest; goodbye ;;
    *) usage; exit 1 ;;
esac

goodbye
