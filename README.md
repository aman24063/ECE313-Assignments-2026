# ECE313-Assignments-2026

This repository contains my assignments for the VDF (UNIX/TCL) course, ECE313.

## Assignment 1 — Text File Analyzer

**Files:**
- `code.tcl` — TCL script
- `code.sh` — Shell script

Both scripts analyze a given text file and print:
- Total number of words
- Total number of lines
- Total number of characters (excluding spaces, newlines, and tabs)
- The longest word in the file
- The shortest word in the file
- Author name and roll number

**Requirements:**
- `code.tcl` requires `tclsh` installed
- `code.sh` requires Bash (standard on any UNIX/Linux system)

**How to Run:**

TCL script:
```bash
tclsh code.tcl <filename>
```
Example:
```bash
tclsh code.tcl sample.txt
```

Shell script:
```bash
bash code.sh <filename>
```
Example:
```bash
bash code.sh sample.txt
```


