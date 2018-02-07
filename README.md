# GPUPoll_Into_InfluxDB
Polls GPUs (such as in a mining rig) for various stats and inserts them into InfluxDB (such as for Grafana)

Designed for use on Windows with WSL. Uses nvidia-smi tool to gather data. Posts data to influxdb every second or so. 
Inspiration and some code from @ayufan [here.](https://gist.github.com/ayufan/41a05fb6f5840a1f2b4335f01498ff1a)

Set up for 4 GPUs currently. Add another `get_data_gpu#` function for each, and incriment the `-i` value. 
Then change the outputData to include the new function by adding `$'\n'"$(get_data_gpu# $METRICS)"` to the end for each new one.
