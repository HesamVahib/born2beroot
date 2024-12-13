#!/bin/bash
arc=$(uname -a)                               # Get system architecture and kernel version
pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l) # Count the number of physical CPUs
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)               # Count the number of virtual CPUs
fram=$(free -m | awk '$1 == "Mem:" {print $2}')               # Get total RAM in MB
uram=$(free -m | awk '$1 == "Mem:" {print $3}')               # Get used RAM in MB
pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}') # Calculate RAM usage percentage
fdisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}') # Get total disk size in GB
udisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}') # Get used disk space in MB
pdisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}') # Calculate disk usage percentage
cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}') # Get CPU load percentage
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')        # Get the last boot date and time
lvmt=$(lsblk | grep "lvm" | wc -l)                           # Check if LVM is being used (count of LVM partitions)
lvmu=$(if [ $lvmt -eq 0 ]; then echo no; else echo yes; fi)  # Determine if LVM is active (yes/no)
#You need to install net tools for the next step [$ sudo apt install net-tools]
ctcp=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}') # Count the number of TCP connections
ulog=$(users | wc -w)                                        # Count the number of currently logged-in users
ip=$(hostname -I)                                            # Get the IP address of the machine
mac=$(ip link show | awk '$1 == "link/ether" {print $2}')    # Get the MAC address of the machine
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)         # Count the number of sudo commands executed
