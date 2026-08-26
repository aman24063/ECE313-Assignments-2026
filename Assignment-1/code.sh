#!/bin/bash
# Shell script to analyze a text file
# Usage: bash code.sh <filename>
# Author: Aman Pal (Roll No: 2024063)

# Check filename argument was given
if [ $# -lt 1 ]; then
    echo "Usage: bash code.sh <filename>"
    exit 1
fi

filename="$1"

# Check file exists
if [ ! -f "$filename" ]; then
    echo "File not found: $filename"
    exit 1
fi

# Total lines (awk counts last line even without trailing newline)
totalLines=$(awk 'END{print NR}' "$filename")

# Total words
totalWords=$(wc -w < "$filename")

# Total characters excluding spaces, newlines, and tabs
totalChars=$(tr -d ' \n\t' < "$filename" | wc -c)

# Find longest and shortest word
longest=""
shortest=""
for word in $(cat "$filename"); do
    len=${#word}
    if [ -z "$longest" ] || [ "$len" -gt "${#longest}" ]; then
        longest="$word"
    fi
    if [ -z "$shortest" ] || [ "$len" -lt "${#shortest}" ]; then
        shortest="$word"
    fi
done

# Print results
echo "File Name        : $filename"
echo "Total Lines       : $totalLines"
echo "Total Words       : $totalWords"
echo "Total Characters  : $totalChars"
echo "Longest Word      : $longest"
echo "Shortest Word     : $shortest"
echo "Name              : Aman Pal"
echo "Roll Number       : 2024063"
