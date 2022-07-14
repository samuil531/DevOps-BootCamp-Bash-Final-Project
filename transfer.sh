#!/bin/bash

#######################################
# Uploads files to transfer.sh
# Globals:
# None
# Arguments:
#$@
# Outputs:
# Writes upload process and result info to stdout
# Returns:
# 1 error
#######################################

currentVersion="1.23.0"

#Upload
httpSingleUpload() {
  for i in "$@"; do
    file=$i
    echo " Uploading ""$i"""
    response=$(curl --progress-bar --upload-file "$1" "https://transfer.sh/$file") || { echo " Failure!"; return 1;}
    echo " Transfer File URL: ""$response""" 
  done
}

#Download
single_download() {
  if [[ ! -d $2 ]];then 
    echo "Creating missing directory..."
    mkdir -p "$2/$3"
  fi
  echo " Downloading ""$4"""
  response=$(curl --progress-bar --create-dirs -o "$4" "https://transfer.sh/" --output-dir ./"$2"/"$3") || { echo -e "\033[31m Failure!\033[37m"; return 1;}
  printDownloadResponse
}

#Prints
printDownloadResponse() {
  echo " Success! "
}

#help
help() 
{
 echo " Description: Bash tool to transfer files from the command line. 
        Usage: 
        -d  Download file from https://transfer.sh/{particular folder} 
        -h  Show the help about attributes 
	-v  Get the tool version 
    
        Examples: 
          ./transfer.sh test.txt               - upload single file	  
	  ./transfer.sh test.txt test2.txt ... - upload multiple files	  
	  ./transfer.sh -v                     - version
	  ./transfer.sh -h                     - view help"
}

#main
main()
{
  if [[ $1 == "-d" ]]; then
    singledownload "$@"
  elif [[ $1 == "-v" ]]; then
    echo "$currentVersion"
  elif [[ $1 == "-h" ]]; then
    help
    else
    httpSingleUpload "$@"
  fi
}

#call main
main "$@"
