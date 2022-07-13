#!/bin/bash

currentVersion="1.23.0"

httpSingleUpload()
{
   response=$(curl -A curl -# --upload-file "$1" "https://transfer.sh/$2") || { echo "Failure!"; return 1;}
   printUploadResponse
}

printUploadResponse()
{
fileID=$(echo "$response" | cut -d "/" -f 4)
  cat <<EOF
Transfer File URL: $response
EOF
}

singleUpload()
{
  for i in "$@"
  do
    
    #filePath=$(echo "$i" | sed 's/~/$HOME/g')
    filePath=$i ; echo "${i//~/$HOME}"

    if [ ! -e "$filePath" ]; then
    {
      echo "Error: invalid file path";
      return 1;
    };
    fi

    tempFileName=$(echo "$i" | sed "s/.*\///")
    echo "Uploading $tempFileName"
    httpSingleUpload "$filePath" "$tempFileName"
  done
}

singleDownload()
{
  filePath=$(echo "$1" | sed 's/\.\///g')
  
  if [ ! -d "$filePath" ]
  then
    mkdir "$filePath"
   # echo "create $filePath"	    
  fi
  
  echo "Downloading $3"
  response=$(curl -# --url "https://transfer.sh/$2/$3" --output "$filePath/$3")
  printDownloadResponse
}

printDownloadResponse()
{
  fileID=$(echo "$response" | cut -d "/" -f 4)
  cat <<EOF
Success! $fileID
EOF
}

singleUpload "$1"
