#!/bin/bash

#Compile
for file in ./*.ui
do
	echo Compiling $file
	rbuic4 -o ../gui/$file $file
done

#Rename
for file in ../gui/*.ui
do
	mv "$file" "${file%.ui}.rb"
done