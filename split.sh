#!/bin/bash

until [ -f /home/app/rdy ]
do
     sleep 1
done
echo "split service ready: starting split ..."

poetry run split_input_files
