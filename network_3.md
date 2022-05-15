# Лекция 3
##### 1.  
``` route-views>show ip route 92.240.212.234 ```  
```
Routing entry for 92.240.212.0/23
  Known via "bgp 6447", distance 20, metric 0
  Tag 6939, type external
  Last update from 64.71.137.241 7w0d ago
  Routing Descriptor Blocks:
  * 64.71.137.241, from 64.71.137.241, 7w0d ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 6939
      MPLS label: none
```  
``` route-views>show bgp 92.240.212.234 ```  
```
BGP routing table entry for 92.240.212.0/23, version 327297785
Paths: (24 available, best #24, table default)
  Not advertised to any peer
  Refresh Epoch 1
  7018 6453 20485 50923 39735
    12.0.1.63 from 12.0.1.63 (12.0.1.63)
      Origin IGP, localpref 100, valid, external
      Community: 7018:5000 7018:37232
      path 7FE0A1A0D5A8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 20764 20764 20764 20764 20764 20764 20764 20764 20764 50923 50923 50923 50923 39735
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE0CFC7BCF8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  53767 174 3216 3216 50923 39735
    162.251.163.2 from 162.251.163.2 (162.251.162.3)
      Origin IGP, localpref 100, valid, external
      Community: 174:21101 174:22010 53767:5000
      path 7FE122049448 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20912 3257 3356 3216 50923 39735
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin IGP, localpref 100, valid, external
      Community: 3257:8070 3257:30515 3257:50001 3257:53900 3257:53902 20912:65004
      path 7FE141B3EEC0 RPKI State not found
      rx pathid: 0, tx pathid: 0
```  
##### 2.  
``` ip link add dummy0 type dummy ```  
``` sudo ip addr add 192.168.0.1/24 dev dummy0 ```  
``` sudo ip link set dummy0 up ```  
``` ip route show ```  
```
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
10.0.0.0/24 via 10.10.10.10 dev eth0 proto static onlink
10.0.1.0/24 via 10.10.10.10 dev eth0 proto static onlink
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
192.168.0.0/24 dev dummy0 proto kernel scope link src 192.168.0.1
```  
##### 3-4.  
``` ss -tulpn ```  
```
Netid    State     Recv-Q     Send-Q          Local Address:Port         Peer Address:Port    Process
udp      UNCONN    0          0               127.0.0.53%lo:53                0.0.0.0:*
udp      UNCONN    0          0              10.0.2.15%eth0:68                0.0.0.0:*
tcp      LISTEN    0          4096            127.0.0.53%lo:53                0.0.0.0:*
tcp      LISTEN    0          128                   0.0.0.0:22                0.0.0.0:*
tcp      LISTEN    0          128                      [::]:22                   [::]:*
```  
##### 5.  
![Untitled Diagram drawio](https://user-images.githubusercontent.com/89702147/168489729-179b1f9c-0108-484a-9655-8fa7badf2bd8.png)
