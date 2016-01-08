#!/bin/bash
# This script iterates over directories and creates new weather file in each dir

src=$1 # path name

echo "author:" $USER

for dir in `ls "$src/"`
do
    if [[ $dir == 2013* ]]
    then
    for file1 in `ls "$src/$dir/"`
    do
        if [[ $file1 == *gps* ]]
        then
        (python get.py $src/$dir/$file1) > $src/$dir/$dir-weather-data.json
        ((python parse.py $src/$dir/$dir-weather-data.json) > $src/$dir/$dir-weather.txt)
        echo done task
        fi
    done
    fi
done
