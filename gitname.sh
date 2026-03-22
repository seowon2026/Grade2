#!/bin/bash

# [기존이름]=변경할이름
declare -A folders=(
    ["데이터구조"]="Data-Structure"
    ["웹프로그래밍1"]="Web-Programming1"
    ["IoT기초실험"]="IoT-Basic-Experiment"
    ["논리회로"]="Logic-Circuit"
)


for key in "${!folders[@]}"; do
    value="${folders[$key]}"

    if [ -d "$key" ]; then
        mv "$key" "$value"
        echo "$key → $value 변경"
    elif [ -d "$value" ]; then
        mv "$value" "$key"
        echo "$value → $key 변경"
    else
        echo "$key / $value 둘 다 없음"
    fi
done
