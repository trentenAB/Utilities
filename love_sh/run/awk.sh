#!/bin/bash
# grep $1
awk -v num="$1" '$2==num'