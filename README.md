Лекция 1
1. установил VBox
2. установил Vagrant взяв установщик с git https://github.com/hashicorp/vagrant-installers/releases/tag/v2.2.19.dev%2Bmain
3. подготовил cmd
4. vagrant init сделано
vagrant up не выполняется без vpn (что очень неприятно, т.к. не все смогут выполнить задание и вероятно стоит пересмотреть курс в текущие ситуации)
vagrant suspend сделано
5. оперативной памяти - 1024Гб (по умолчанию), процессор - 2, видеопамять - 4Мб, носитель - 64Гб, сеть - NAT (по умолчанию), общая папка.
6. v.memory = ??? v.cpus = ???
7. выполнено
8. HISTFILESIZE 1104 строка
ignoreboth - не записывает команду, которая начинается с пробела, либо дублирующая предыдущую
9. в 1541 строке, для указания массива параметров
10. touch f{1..100000}, больше 137867 не получится создать из-за проверки на максимальное кол-во параметров
11. проверяет на существование каталога, вернет 0 (истину) так как каталог "/tmp" существует
12. mkdir /tmp/newDir
cp /bin/bash /tmp/newDir/bash
export PATH="/tmp/newDir/:$PATH"
13. batch является псевдонимом 'at -b'
14. vagrant halt только для остановки
или vagrant destroy для остановки и удаления

Лекция 2
1. cd is a shell builtin
2. grep <some_string> <some_file> -c
3. systemd
4. ls /tmp 2 > /dev/pts/2
5. cat < 1.txt > 2.txt
6. Получится через перенаправление на эмулятор терминала ctrl+alt+f1...f6
7. создаст дескриптор fd/5 и перенаправит в stdout
выведет netology на экран, т.к. вывод echo перенаправлен в fd/5, который перенаправлен в stdout
8. ll ./ 55>&2 2>&1 1>&55
9. выведет переменные окружения. При помощи env.
10. /proc/<PID>/cmdline
  содержит полную командную строку запуска процесса
/proc/<PID>/exe
  символьная ссылка, содержащая фактическое полное имя выполняемого файла
11. sse4_2
12. ssh -t localhost 'tty'
13. reptyr -T <PID>
14. tee читает из input в output и файл. Работает потому что запущена из под рут и 

Лекция 3
1. chdir("/tmp")
2. openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
3. echo '' > /proc/<PID>/fd/3
4. нет, остается только запись в таблице процессов
5.vagrant@vagrant:~$ sudo /usr/sbin/opensnoop-bpfcc
PID    COMM               FD ERR PATH
856    vminfo              6   0 /var/run/utmp
621    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
621    dbus-daemon        20   0 /usr/share/dbus-1/system-services
621    dbus-daemon        -1   2 /lib/dbus-1/system-services
621    dbus-daemon        20   0 /var/lib/snapd/dbus-1/system-services/
629    irqbalance          6   0 /proc/interrupts
629    irqbalance          6   0 /proc/stat
629    irqbalance          6   0 /proc/irq/20/smp_affinity
629    irqbalance          6   0 /proc/irq/0/smp_affinity
629    irqbalance          6   0 /proc/irq/1/smp_affinity
629    irqbalance          6   0 /proc/irq/8/smp_affinity
629    irqbalance          6   0 /proc/irq/12/smp_affinity
629    irqbalance          6   0 /proc/irq/14/smp_affinity
629    irqbalance          6   0 /proc/irq/15/smp_affinity
6. Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.
7. при ; команды будут запущены последовательно в любом случае. При && команды будут запущены последовательно, только при успешном выполнении предыдущей команды.
8. set -euxo pipefail
-e - прекращает выполнение скрипта если команда завершилась ошибкой, выводит в stderr строку с ошибкой
-u - прекращает выполнение скрипта, если встретилась несуществующая переменная
-x - выводит выполняемые команды в stdout перед выполненинем
-o pipefail - прекращает выполнение скрипта, даже если одна из частей пайпа завершилась ошибкой
Хорошо использовать потому что происходит автоматическая обработка ошибок.
9. Ss - процесс, ожидающий завершения
R+ - процесс выполняется

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
