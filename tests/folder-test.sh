#!/bin/bash

EXPECTED_SUBFOLDERS=(asm asm/src asm/obj asm/bin)
EXPECTED_FILES=(asm/src/main.s asm/src/main.c asm/Makefile asm/relazione.pdf)

# check for subfolders
for subfolder in "${EXPECTED_SUBFOLDERS[@]}"; do
    if [ ! -d "$subfolder" ]; then
        echo "Subfolder $subfolder not found"
        exit 1
    fi
done

# check for files in subfolder
for file in "${EXPECTED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "File $file not found"
        exit 1
    fi
done