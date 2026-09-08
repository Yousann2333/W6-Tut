#!/bin/bash
 
ANALYSIS_FILE="$HOME/analysisData.log"
SUMMARY_FILE="$HOME/summary.log"
 
if [ "$#" -eq 0 ]; then
    dir="$PWD"
elif [ "$#" -eq 1 ]; then
    if [ -d "$1" ]; then
        dir="$1"
    else
        echo -e "usage: arg needs to be a directory.\n"
        exit 1
    fi
else
    echo -e "usage: more than 1 arg is not allowed.\n"
    exit 2
fi
 
dir="$(cd "$dir" && pwd)"
echo "$dir"
 
total=0
max=-1
maxfile=""
files=0
 
: > "$ANALYSIS_FILE"
 
while IFS= read -r -d '' f; do
    count="$(grep -c -i -- "error" "$f" || true)"
 
    echo "******************" | tee -a "$ANALYSIS_FILE"
    echo "Filename: $f <No. of errors found = $count>" | tee -a "$ANALYSIS_FILE"
 
    total=$(( total + count ))
    files=$(( files + 1 ))
 
    if [ "$count" -gt "$max" ]; then
        max="$count"
        maxfile="$f"
    fi
done < <(find "$dir" -maxdepth 1 -type f -name '*log' \
             ! -name "analysisData.log" ! -name "summary.log" \
             -mtime -7 -print0)
 
if [ "$files" -eq 0 ]; then
    echo -e "No. of modified log files: 0\n"
    exit 0
fi
 
echo "------------------"
 
{
    echo "Total errors found:$total"
    echo "File with the max errors:$maxfile, <error-count:$max>"
} | tee "$SUMMARY_FILE"
 
exit 0
 

