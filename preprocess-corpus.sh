#!/bin/bash

if [ $# -ne 4 ]; then
  echo "Error: Wrong number of arguments"
  echo "Usage: $0 <filein.sl> <filein.tl> <fileout.sl> <fileout.tl>"
  exit 1
fi

file_sl="$1"
file_tl="$2"

file_sl_out="$3"
file_tl_out="$4"

if [ ! -f "$file_sl" ]; then
  echo "Error: File '$file_sl' does not exist."
  exit 1
fi

if [ ! -f "$file_tl" ]; then
  echo "Error: File '$file_tl' does not exist."
  exit 1
fi

if [ -f "$file_sl_out" ]; then
  echo "Error: File '$file_sl_out' already exist."
  echo "Please remove it"
  exit 1
fi

if [ -f "$file_tl_out" ]; then
  echo "Error: File '$file_tl_out' already exist."
    echo "Please remove it"
  exit 1
fi

lines_sl=$(wc -l < "$file_sl")
lines_tl=$(wc -l < "$file_tl")

if [ "$lines_sl" -ne "$lines_tl" ]; then
  echo "Error: The files provide do not contain the same number of lines:"
  echo "   $file_sl: $lines_sl lines"
  echo "   $file_tl: $lines_tl lines"
fi

temp=$(mktemp -p "$PWD")

cat $file_sl | sed -re "s/^\s+//g" | sed -re "s/\s+$//g" | sed -re "s/\s+/ /g" > $temp"-sl"
cat $file_tl | sed -re "s/^\s+//g" | sed -re "s/\s+$//g" | sed -re "s/\s+/ /g" > $temp"-tl"

paste $temp"-sl" $temp"-tl" | sort | uniq |\
awk -F$'\t' '{if (($1!="")&&($2!="")) print}' | shuf > $temp-"sltl"

cut -f1 $temp-"sltl" > "$file_sl_out"
cut -f2 $temp-"sltl" > "$file_tl_out"

rm $temp-"sltl" $temp"-sl" $temp"-tl"

