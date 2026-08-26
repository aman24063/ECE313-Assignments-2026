#!/usr/bin/env tclsh
# TCL script to analyze a text file
# Usage: tclsh code.tcl <filename>
# Author: Aman Pal (Roll No: 2024063)

# Check filename argument was given
if {$argc < 1} {
    puts "Usage: tclsh code.tcl <filename>"
    exit 1
}

set filename [lindex $argv 0]

# Read the file
set fp [open $filename r]
set content [read $fp]
close $fp

# Count lines
set lines [split $content "\n"]
if {[lindex $lines end] eq ""} {
    set lines [lrange $lines 0 end-1]
}
set totalLines [llength $lines]

# Count characters excluding spaces, newlines, and tabs
set totalChars 0
foreach ch [split $content ""] {
    if {$ch ne " " && $ch ne "\n" && $ch ne "\t"} {
        incr totalChars
    }
}

# Count words
set words [regexp -all -inline {\S+} $content]
set totalWords [llength $words]

# Find longest and shortest word
set longest [lindex $words 0]
set shortest [lindex $words 0]
foreach w $words {
    if {[string length $w] > [string length $longest]} {
        set longest $w
    }
    if {[string length $w] < [string length $shortest]} {
        set shortest $w
    }
}

# Print results
puts "Total Words:      $totalWords"
puts "Total Lines:      $totalLines"
puts "Total Characters: $totalChars"
puts ""
puts "Longest Word:  $longest"
puts "Shortest Word: $shortest"
puts ""
puts "Prepared by: Aman Pal"
puts "Roll Number: 2024063"
