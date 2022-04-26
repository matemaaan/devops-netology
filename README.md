Лекция 4
1. wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar -xf node_exporter-1.3.1.linux-amd64.tar.gz
sudo cp node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin/
sudo nano /etc/systemd/system/node_exporter.service

[Unit]
Description=Node Exporter
After=network.target

[Service]
Type=simple
User=vagrant
Group=vagrant
ExecStart=/usr/local/bin/node_exporter
EnvironmentFile=/etc/default/node_exporter

SyslogIdentifier=node_exporter
Restart=always

PrivateTmp=yes
ProtectHome=yes
NoNewPrivileges=yes

ProtectSystem=strict
ProtectControlGroups=true
ProtectKernelModules=true
ProtectKernelTunables=yes

[Install]
WantedBy=multi-user.target


sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter


vagrant@vagrant:~$ vagrant@vagrant:~$ ps -e | grep node_
   2042 ?        00:00:00 node_exporter

vagrant@vagrant:~$ sudo cat /proc/2042/environ
LANG=en_US.UTF-8PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/binHOME=/home/vagrantLOGNAME=vagrantUSER=vagrantSHELL=/bin/bashINVOCATION_ID=6ccf5102603344a2bb0f0ea372521749JOURNAL_STREAM=9:34080

vagrant@vagrant:~$ cat /etc/default/node_exporter
LANG=en_US.UTF-8
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
HOME=/home/vagrant
LOGNAME=vagrant
USER=vagrant
SHELL=/bin/bash
INVOCATION_ID=6ccf5102603344a2bb0f0ea372521749
JOURNAL_STREAM=9:34080

2.
node_cpu_seconds_total{cpu="0",mode="idle"} 439.84
node_cpu_seconds_total{cpu="0",mode="iowait"} 1.03
node_cpu_seconds_total{cpu="0",mode="irq"} 0
node_cpu_seconds_total{cpu="0",mode="nice"} 0
node_cpu_seconds_total{cpu="0",mode="softirq"} 0.3
node_cpu_seconds_total{cpu="0",mode="steal"} 0
node_cpu_seconds_total{cpu="0",mode="system"} 4.7
node_cpu_seconds_total{cpu="0",mode="user"} 2.5
node_cpu_seconds_total{cpu="1",mode="idle"} 440.94
node_cpu_seconds_total{cpu="1",mode="iowait"} 0.96
node_cpu_seconds_total{cpu="1",mode="irq"} 0
node_cpu_seconds_total{cpu="1",mode="nice"} 0
node_cpu_seconds_total{cpu="1",mode="softirq"} 0.63
node_cpu_seconds_total{cpu="1",mode="steal"} 0
node_cpu_seconds_total{cpu="1",mode="system"} 3.08
node_cpu_seconds_total{cpu="1",mode="user"} 2.15

node_memory_MemAvailable_bytes 7.03279104e+08
node_memory_MemFree_bytes 2.195456e+08
node_memory_MemTotal_bytes 1.028685824e+09

node_disk_io_now{device="dm-0"} 0
node_disk_io_now{device="sda"} 0
node_disk_io_time_seconds_total{device="dm-0"} 5.952
node_disk_io_time_seconds_total{device="sda"} 6.0280000000000005
node_disk_read_bytes_total{device="dm-0"} 5.09338624e+08
node_disk_read_bytes_total{device="sda"} 5.1913728e+08
node_disk_read_time_seconds_total{device="dm-0"} 7.228
node_disk_read_time_seconds_total{device="sda"} 4.817

node_network_receive_bytes_total{device="eth0"} 537381
node_network_receive_bytes_total{device="lo"} 74999
node_network_receive_errs_total{device="eth0"} 0
node_network_receive_errs_total{device="lo"} 0
node_network_receive_packets_total{device="eth0"} 2592
node_network_receive_packets_total{device="lo"} 260

3.в прикрепленном файле

4. vagrant@vagrant:~$ dmesg | grep -i virtual
[    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[    0.000932] CPU MTRRs all blank - virtualized system.
[    0.053030] Booting paravirtualized kernel on KVM
[    3.270519] systemd[1]: Detected virtualization oracle.

5. vagrant@vagrant:~$ sysctl -n fs.nr_open
1048576
vagrant@vagrant:~$ ulimit -n
1024

6. root@vagrant:/home/vagrant# unshare -f --pid --mount-proc sleep 1h

root@vagrant:/home/vagrant# ps -e | grep sleep
   1182 pts/0    00:00:00 sleep
root@vagrant:/home/vagrant# nsenter --target 1182 --mount --uts --ipc --net --pid ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   5476   592 pts/0    S+   12:20   0:00 sleep 1h
root           2  0.0  0.3   8892  3308 pts/1    R+   12:20   0:00 ps aux

7. запускает много bash
root@vagrant:/home/vagrant# dmesg | grep fork
[ 1006.179790] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-1.scope
при помощи limit -u {кол-во} можно изменить число процессов
