#!/bin/bash

export PATH=$PATH:"/mnt/c/Program Files/NVIDIA Corporation/NVSMI"

join_by() {
        local IFS=","
        echo "$*"
}

get_data_gpu0() {
        local QUERIES=$(join_by "$@")
        while read -d "," VALUE REST; do
                echo "$1,hostname=$HOSTNAME,gpu=0 value=$VALUE"
                shift
        done < <(nvidia-smi.exe -i 0 --query-gpu="${QUERIES[@]}" --format=csv | tail -n 1)
}

get_data_gpu1() {
        local QUERIES=$(join_by "$@")
        while read -d "," VALUE REST; do
                echo "$1,hostname=$HOSTNAME,gpu=1 value=$VALUE"
                shift
        done < <(nvidia-smi.exe -i 1 --query-gpu="${QUERIES[@]}" --format=csv | tail -n 1)
}

get_data_gpu2() {
        local QUERIES=$(join_by "$@")
        while read -d "," VALUE REST; do
                echo "$1,hostname=$HOSTNAME,gpu=2 value=$VALUE"
                shift
        done < <(nvidia-smi.exe -i 2 --query-gpu="${QUERIES[@]}" --format=csv | tail -n 1)
}

get_data_gpu3() {
        local QUERIES=$(join_by "$@")
        while read -d "," VALUE REST; do
                echo "$1,hostname=$HOSTNAME,gpu=3 value=$VALUE"
                shift
        done < <(nvidia-smi.exe -i 3 --query-gpu="${QUERIES[@]}" --format=csv | tail -n 1)
}

get_data_gpus() {
        local QUERIES=$(join_by "$@")
        while read -d "," VALUE REST; do
                echo "$1,hostname=$HOSTNAME,gpu=3 value=$VALUE"
                shift
        done < <(nvidia-smi.exe -i 3 --query-gpu="${QUERIES[@]}" --format=csv | tail -n 1)
}

METRICS="power.draw power.limit temperature.gpu
        clocks.current.graphics clocks.current.sm clocks.current.memory clocks.current.video
        utilization.gpu utilization.memory memory.used memory.total memory.free 
	fan.speed"

while true; do
	outputData="$(get_data_gpu0 $METRICS)"$'\n'"$(get_data_gpu1 $METRICS)"$'\n'"$(get_data_gpu2 $METRICS)"$'\n'"$(get_data_gpu3 $METRICS)"
	# echo "$outputData"
	curl -i -XPOST "(fill in with InfluxDB URL and port)/write?db=(fill in with dbname)&u=(fill in with username)&p=(fill in with password)" --data-binary "$outputData"
	sleep 1
done
