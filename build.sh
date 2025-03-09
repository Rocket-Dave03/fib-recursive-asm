#!/bin/bash
set -euo pipefail

mkdir -p ./build/
nasm -g -f elf64 ./main.asm -o ./build/main.o
ld ./build/main.o -o ./build/main
