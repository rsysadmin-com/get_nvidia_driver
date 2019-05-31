#!/bin/bash

#
# get_nvidia_driver.sh
# by martin@mielke.com
#
# quick and dirty script to fetch nVidia's latest driver for Linux.
#
# ./get_nvidia_driver.sh -h for help
#
# Disclaimer: this script is provided on an "AS IS" basis.
# The autor is not to held responsible for the use, misuse and/or any damage
# that this little tool may cause.
#

# some variables
nvidia_url=https://download.nvidia.com/XFree86/Linux-x86_64     # URL where the drivers are
nvidia_latest=$nvidia_url/latest.txt                            # file with the latest info
target_dir=$(pwd)                                               # where to store the downloaded file
t=30                                                            # time, in seconds, for the countdown function


 function banner() {

    echo -e "\nLinux nVidia Driver Downloader"
    echo "by martin@mielke.com"
    echo -e "==============================\n"
}

function usage() {  # option: -h
    cat << EOF
$(basename $0) [-h][-d][-i]
            -h Prints this help
            -d Download only 
            -i (root only) Download and install
            
EOF
}

function returnStatus { # helper funcion
    if [[ $? -eq 0 ]]
    then
        echo -e "[ PASS ]"
    else
        echo -e "[ FAIL ]"
    fi
}

function get_latest() {
    # get latest version
    echo -e "= Fetching latest nVidia driver version... \c"
    wget -q $nvidia_latest -O latest.txt
    returnStatus
    nvidia_driver=$(awk '{ print $2 }' latest.txt)
    nvidia_driver_version=$(awk '{ print $1 }' latest.txt)
    nvidia_driver_file=$(awk -F/ '{ print $2 }' latest.txt)
    echo "= Latest version available on nVidia's website: $nvidia_driver_version"
}

function countdown() {  # yep, a countdown
    m=${1}-1 # add minus 1 

            floor () {
                dividend=${1}
                divisor=${2}
                result=$(( ( ${dividend} - ( ${dividend} % ${divisor}) )/${divisor} ))
                echo ${result}
            }

            timecount(){
                s=${1}
                hour=$( floor ${s} 60/60 )
                s=$((${s}-(60*60*${hour})))
                min=$( floor ${s} 60 )
                sec=$((${s}-60*${min}))
                while [ $hour -ge 0 ]; do
                    while [ $min -ge 0 ]; do
                            while [ $sec -ge 0 ]; do
                                    printf "\t%02d:%02d:%02d\033[0k\r" $hour $min $sec
                                    sec=$((sec-1))
                                    sleep 1
                            done
                            sec=59
                            min=$((min-1))
                    done
                    min=59
                    hour=$((hour-1))
                done
            }

        timecount $m
}


function download_file() {  # and another helper function
    if [ -r $target_dir/$nvidia_driver_file ]
        then
            echo "= Found local copy of $nvidia_driver_file ..."
            ls -l $target_dir/$nvidia_driver_file
            echo -e "\nMy job is done...\n"
        else
            echo -e "= Downloading latest nVidia driver file... \c"
            wget -q $nvidia_url/$nvidia_driver
            returnStatus
        fi
}
        
function download_only() {  # option: -d
    if [ -r $target_dir/$nvidia_driver_file ]
    then
        echo "= Found local copy of $nvidia_driver_file ..."
        ls -l $target_dir/$nvidia_driver_file
        echo -e "\nMy job is done...\n"
    else
        download_file
        echo "= I placed a copy of the downloaded file under $target_dir"
        echo "= and also added execution permissions to it..."
        chmod +x $target_dir/$nvidia_driver_file
        ls -l $target_dir/$nvidia_driver_file
    fi

}

function download_install() {   # option: -i
 
    download_file
    
    echo -e "\n= Following is going to happen::\n"
    echo -e "\t 1) I'll take the system to run-level 3"
    echo -e "\t 2) run the install script I just downloaded\n"
    
    echo -e "\tYou have $t seconds to hit ctrl-c if you want to stop me..."
    
    countdown $t    
    
    init 3 && $target_dir/$nvidia_driver_file -Xq

}

function ru_root() {    # another helper function
    # check if we are root.. if not, stop right here, right now.
    # may be an unnecessary check but, hey! you never know...
    if [[ $UID -ne 0 ]]
    then
        echo -e "\tWARNING\tNice try! Are you root?..."
        echo -e "\tBecome root and run this script again...\n"
        exit 3
    fi
}

#------------------------------------------------------
# Main
#------------------------------------------------------

set -- `getopt hdi $*`

if [[ $? -ne 0 ]]
then
        usage
        exit
fi

banner

for arg in $*
do
        case $arg in
        -h) usage; exit 1;;
        -d) get_latest; download_only; exit 0;;
        -i) ru_root; get_latest; download_install; exit 0;;
        *) usage; exit 0;;
        esac
done

# The end.


