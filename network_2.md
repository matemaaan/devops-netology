# Компьютерные сети (лекция 2)  
##### 1.  
ubuntu: ```ip a ```  
windows: ``` ipconfig ```  
  
##### 2.  
```
протокол: LLDP  
пакет:  lldpd
команда:  lldpctl
```  
##### 3.  
Технология VLAN  
``` sudo apt-get install vlan ```  
``` sudo modprobe 8021q ```  
``` sudo vconfig add eth1 10 ```  
``` sudo ip link add link eth1 name eth1.10 type vlan id 10 ```  
``` sudo ip addr add 192.168.0.1/24 dev eth1.10 ```
``` sudo ip link set up eth1.10 ```  

Чтобы указать навсегда  
``` sudo su -c 'echo "8021q" >> /etc/modules' ```  
```
auto eth1.10
iface eth1.10 inet static
    address 192.168.0.1
    netmask 255.255.255.0
    vlan-raw-device eth1
```  
##### 4.  
Типы агрегации (LAG): статический (на Cisco mode on) и динамический (на Cisco mode active).  
  
``` apt install ifenslave ```  
   
``` ifdown eth0 ``` (и другие)
``` /etc/init.d/networking stop ```  
  
прописать в /etc/network/interfaces, например
```
auto bond0

iface bond0 inet static
    address 10.1.1.5
    netmask 255.255.255.0
    network 10.1.1.0
    gateway 10.1.1.254
    bond-slaves eth0 eth1
    bond-mode active-backup
    bond-miimon 100
    bond-downdelay 200
    bond-updelay 200
```  
##### 5.  
8 адресов в сети с маской /29  
```
ipcalc 192.168.1.1/29  
  
Address:   192.168.1.1          11000000.10101000.00000001.00000 001  
Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000  
Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111  
=>  
Network:   192.168.1.0/29       11000000.10101000.00000001.00000 000  
HostMin:   192.168.1.1          11000000.10101000.00000001.00000 001  
HostMax:   192.168.1.6          11000000.10101000.00000001.00000 110  
Broadcast: 192.168.1.7          11000000.10101000.00000001.00000 111  
Hosts/Net: 6                     Class C, Private Internet  
```  

Можно получить 32 /29 подсети из сети с маской /24.
Пример:
```
1. Requested size: 8 hosts  
Netmask:   255.255.255.240 = 28 11111111.11111111.11111111.1111 0000  
Network:   192.168.1.0/28       11000000.10101000.00000001.0000 0000  
HostMin:   192.168.1.1          11000000.10101000.00000001.0000 0001  
HostMax:   192.168.1.14         11000000.10101000.00000001.0000 1110  
Broadcast: 192.168.1.15         11000000.10101000.00000001.0000 1111  
Hosts/Net: 14                    Class C, Private Internet  
  
2. Requested size: 8 hosts  
Netmask:   255.255.255.240 = 28 11111111.11111111.11111111.1111 0000  
Network:   192.168.1.16/28      11000000.10101000.00000001.0001 0000  
HostMin:   192.168.1.17         11000000.10101000.00000001.0001 0001  
HostMax:   192.168.1.30         11000000.10101000.00000001.0001 1110  
Broadcast: 192.168.1.31         11000000.10101000.00000001.0001 1111  
Hosts/Net: 14                    Class C, Private Internet  
  
3. Requested size: 8 hosts  
Netmask:   255.255.255.240 = 28 11111111.11111111.11111111.1111 0000  
Network:   192.168.1.32/28      11000000.10101000.00000001.0010 0000  
HostMin:   192.168.1.33         11000000.10101000.00000001.0010 0001  
HostMax:   192.168.1.46         11000000.10101000.00000001.0010 1110  
Broadcast: 192.168.1.47         11000000.10101000.00000001.0010 1111  
Hosts/Net: 14                    Class C, Private Internet  
```  
##### 6. 
100.64.0.0 — 100.127.255.255 (маска подсети: 255.192.0.0 или /10)  
```
ipcalc 100.64.0.1/26  
Address:   100.64.0.1           01100100.01000000.00000000.00 000001  
Netmask:   255.255.255.192 = 26 11111111.11111111.11111111.11 000000  
Wildcard:  0.0.0.63             00000000.00000000.00000000.00 111111  
=>  
Network:   100.64.0.0/26        01100100.01000000.00000000.00 000000  
HostMin:   100.64.0.1           01100100.01000000.00000000.00 000001  
HostMax:   100.64.0.62          01100100.01000000.00000000.00 111110  
Broadcast: 100.64.0.63          01100100.01000000.00000000.00 111111  
Hosts/Net: 62                    Class A  
```  
##### 7.  
windows:  
вывести ``` arp -a ```  
удалить 1 ``` arp -d 192.168.1.1 ```  
очистить ```  netsh interface ip delete arpcache ```  
linux:  
вывести ``` ip neigh ```  
удалить 1 ``` sudo ip neigh del 192.168.1.100 dev ens33 ```  
очистить ``` sudo ip neigh flush all ```  
