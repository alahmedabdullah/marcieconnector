#!/bin/sh

INPUT_DIR=$1
OUTPUT_DIR=$2

cd $INPUT_DIR

#echo "marcie $(cat cli_parameters.txt)" >> runlog2.txt

marcie $(cat cli_parameters.txt) &> runlog.txt


cp ./*.txt ../$OUTPUT_DIR

# --- EOF ---
