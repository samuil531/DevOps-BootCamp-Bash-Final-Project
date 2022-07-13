#!/bin/bash

currentVersion="1.23.0"

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

#Upload
httpSingleUpload()
{
  for i in "$@"; do
    file=$i
    echo -e " Uploading "$i""
    response=$(curl --progress-bar --upload-file "$1" "https://transfer.sh/$file") || { echo -e "Failure!"; return 1;}
    echo -e "Transfer File URL: "$response"" 
  done
}

#Download
singleDownload()
{
  if [[ ! -d $2 ]];then 
    echo "Creating missing directory..."
    mkdir -p "$2/$3"
  fi
  echo " Downloading "$4""
  d_response=$(curl --progress-bar --create-dirs -o "$4" "https://transfer.sh/" --output-dir ./"$2"/"$3") || { echo -e " Failure!"; return 1;}
  printDownloadResponse
}

#Prints
printDownloadResponse() 
{
  echo -e "Success!"
}

#help
help() 
{
 echo -e " Description: Bash tool to transfer files from the command line. 
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

#mainf
mainf()
{
  if [[ $1 == "-d" ]]; then
    singleDownload "$@"
  elif [[ $1 == "-v" ]]; then
    echo "$currentVersion"
  elif [[ $1 == "-h" ]]; then
    help
    else
    httpSingleUpload "$@"
  fi
}

#call mainf
mainf "$@"
