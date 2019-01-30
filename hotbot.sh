#!/bin/bash
echo RUNNING HENRY
now=$(date +'%F_%T')
echo EXPORTING RESULTS TO output/$now

mkdir -p output/$now
echo RUNNING HENRY PULSE
henry pulse --host $1 --output="output/$now/henry_pulse.txt"
echo ANALYZING PROJECTS
henry analyze projects --host $1 --output="output/$now/henry_analyze_projects.txt"
echo DONE

echo ANALYZING MODELS
henry analyze models --host $1 --output="output/$now/henry_analyze_models.txt"
echo DONE

echo ANALYZING EXPLORES
henry analyze explores --host $1 --output="output/$now/henry_analyze_explores.txt"
echo DONE

echo VACUUMING MODELS
henry vacuum models --host $1 --output="output/$now/henry_vacuum_models.txt"
echo DONE

#building csv from output
#remove first and third row
sed '1d' output/$now/henry_analyze_explores.txt > tmpfile; mv tmpfile output/$now/henry_analyze_explores_csv.txt
sed '2d' output/$now/henry_analyze_explores_csv.txt > tmpfile; mv tmpfile output/$now/henry_analyze_explores_csv.txt
#remove last row
sed '$ d' output/$now/henry_analyze_explores_csv.txt > tmpfile; mv tmpfile output/$now/henry_analyze_explores_csv.txt
#remove first two characters
sed 's/^..//' output/$now/henry_analyze_explores_csv.txt > tmpfile; mv tmpfile output/$now/henry_analyze_explores_csv.txt
#remove last character
sed 's/.$//'  output/$now/henry_analyze_explores_csv.txt > tmpfile; mv tmpfile output/$now/henry_analyze_explores_csv.txt
# replace pipes with commas
sed 's/|/,/g' output/$now/henry_analyze_explores_csv.txt > output/$now/henry_analyze_explores.csv; rm output/$now/henry_analyze_explores_csv.txt

v1=$2
v2=$3
#filter on query_count
awk -v var=${v1} 'BEGIN {FS=","} {if ($9 >= var ) print $0}' output/$now/henry_analyze_explores.csv > tmpfile ; mv tmpfile output/$now/henry_analyze_explores.csv
# filter on unused_fields
awk -v var=${v2} 'BEGIN {FS=","} {if ($8 >= var ) print $0}' output/$now/henry_analyze_explores.csv > tmpfile ; mv tmpfile output/$now/henry_analyze_explores.csv

explores=( $(awk -F "," '{print $2}' ./output/${now}/henry_analyze_explores.csv) )
models=( $(awk -F "," '{print $1}' ./output/${now}/henry_analyze_explores.csv) )

rm output/$now/henry_analyze_explores.csv

for i in ${!explores[*]}; do
  echo VACUUMING EXPLORE, ${explores[i]} IN MODEL, ${models[i]}
  henry vacuum explores --model ${models[i]} --explore ${explores[i]} --host $1 --output="output/$now/henry_vacuum_explores_${models[i]}::${explores[i]}.txt"
  echo DONE
done

echo COMPLETE. PLEASE SEE OUTPUT IN output/${now}/
