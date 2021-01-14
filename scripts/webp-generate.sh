#!/bin/bash

webpGenerate() {

  if [ -d "$(pwd)" ]; then
        for i in "$(pwd)"/*; do
          if [ -f $i ]; then
            extension="${i##*.}"
            filename="${i%%.*}"
            cwebp -q 100 ${i##*/} -o $filename.webp
          fi
        done
        exit
        else
        echo "$0: $folder is not a valid directory"
        exit
      fi
}

while true
do
    read -r -p "Do you want to continue in this directory $(pwd) ? [Y/n]" choice
    case "$choice" in
      n|N) break;;
      *) webpGenerate;;
      y|Y) webpGenerate;;
    esac
done