#!/bin/bash

# iter = 0 WRONG
iter=0

echo "i erst: $iter "

# iter = $((iter+1)) WRONG
# iter = $((iter + 1)) WRONG
iter=$((iter+1))

echo "i nun: $iter "

# Learning: Dont use any whitespace in variable declarations
