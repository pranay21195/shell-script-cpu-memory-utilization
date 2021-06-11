#!/bin/bash

fn="output"

function stats_based_on_cpu() {
  top_cpu_cmd="ps -eo pid,cmd,%cpu,%mem --sort=-%cpu | head -n 4 | \
    awk 'NR==4{print \$1,\$2,\$3,\$4}'"
  readarray -t cpu_lines <<<$(eval "$top_cpu_cmd")

  cpu_arr=($(echo "${cpu_lines[@]}"))
  cpu_pid="${cpu_arr[0]}"
  process_name="${cpu_arr[1]}"
  cpu_usage="${cpu_arr[2]}"
  cpu_mem="${cpu_arr[3]}"
  cpu_port=$(sudo lsof -Pan -p $cpu_pid -i | awk '{print $9}' | cut -d: -f2 | awk 'NR==2{print $1}')
  if [ -z "$cpu_port" ]; then
    cpu_port='-'
  fi

  echo "3rd Most CPU Consumeing Process" >$fn
  printf "%10s%10s%30s%10s%15s%10s%15s%10s%15s\n" "PID" "|" "PROCESS" "|" \
    "%CPU" "|" "%MEM" "|" "PORT" >> $fn
  printf "%10s%10s%30s%10s%15s%10s%15s%10s%15s\n" "$cpu_pid" "|" "$process_name" "|" \
    "$cpu_usage" "|" "$cpu_mem" "|" "$cpu_port" >> $fn

}

function stats_based_on_memory() {
  top_mem_cmd="ps -eo pid,cmd,%cpu,%mem --sort=-%mem | head -n 4 | \
    awk 'NR==4{print \$1,\$2,\$3,\$4}'"
  readarray -t mem_lines <<<$(eval "$top_mem_cmd")

  mem_arr=($(echo "${mem_lines[@]}"))
  mem_pid="${mem_arr[0]}"
  process_name="${mem_arr[1]}"
  cpu_usage="${mem_arr[2]}"
  cpu_mem="${mem_arr[3]}"
  mem_port=$(sudo lsof -Pan -p $mem_pid -i | awk '{print $9}' | cut -d: -f2 | awk 'NR==2{print $1}')
  if [ -z "$mem_port" ]; then
    mem_port='-'
  fi

  echo "3rd Most Memory Consuming Process" >> $fn
  printf "%10s%10s%30s%10s%15s%10s%15s%10s%15s\n" "PID" "|" "PROCESS" "|" \
    "%CPU" "|" "%MEM" "|" "PORT" >> $fn
  printf "%10s%10s%30s%10s%15s%10s%15s%10s%15s\n" "$mem_pid" "|" "$process_name" "|" \
    "$cpu_usage" "|" "$cpu_mem" "|" "$mem_port" >> $fn
}

stats_based_on_cpu
echo >> $fn
echo >> $fn
stats_based_on_memory
