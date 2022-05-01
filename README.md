# Лекция 5  

##### 1.  
``` узнал ```  
##### 2.  
``` Нет, не могут, потому что ссылаются на один и тот же файл и у них одинаковый inode ```  
##### 3.  
``` сделано ```  
##### 4.  
```
sudo fdisk -l  
sudo fdisk /dev/sdb  
Command (m for help): n  
Partition type  
   p   primary (0 primary, 0 extended, 4 free)  
   e   extended (container for logical partitions)  
Select (default p): p  
Partition number (1-4, default 1):  
First sector (2048-5242879, default 2048):  
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G  
  
Created a new partition 1 of type 'Linux' and of size 2 GiB.  
  
Command (m for help): n  
Partition type  
   p   primary (1 primary, 0 extended, 3 free)  
   e   extended (container for logical partitions)  
Select (default p): p  
Partition number (2-4, default 2):  
First sector (4196352-5242879, default 4196352):  
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):  
  
Created a new partition 2 of type 'Linux' and of size 511 MiB.  
  
Command (m for help): w  
The partition table has been altered.  
Calling ioctl() to re-read partition table.  
Syncing disks.  
```
##### 5.  
```
sudo sfdisk -d /dev/sdb | sudo sfdisk /dev/sdc  
Checking that no-one is using this disk right now ... OK  
  
Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors  
Disk model: VBOX HARDDISK  
Units: sectors of 1 * 512 = 512 bytes  
Sector size (logical/physical): 512 bytes / 512 bytes  
I/O size (minimum/optimal): 512 bytes / 512 bytes  
  
>>> Script header accepted.  
>>> Script header accepted.  
>>> Script header accepted.  
>>> Script header accepted.  
>>> Created a new DOS disklabel with disk identifier 0x137d5ccf.  
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.  
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.  
/dev/sdc3: Done.  
  
New situation:  
Disklabel type: dos  
Disk identifier: 0x137d5ccf  
  
Device     Boot   Start     End Sectors  Size Id Type  
/dev/sdc1          2048 4196351 4194304    2G 83 Linux  
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux  
  
The partition table has been altered.  
Calling ioctl() to re-read partition table.  
Syncing disks.  
```  
```
lsblk  
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT  
loop0                       7:0    0 55.4M  1 loop /snap/core18/2128  
loop1                       7:1    0 70.3M  1 loop /snap/lxd/21029  
loop3                       7:3    0 55.5M  1 loop /snap/core18/2344  
loop4                       7:4    0 44.7M  1 loop /snap/snapd/15534  
loop5                       7:5    0 61.9M  1 loop /snap/core20/1434  
loop6                       7:6    0 67.8M  1 loop /snap/lxd/22753  
sda                         8:0    0   64G  0 disk  
├─sda1                      8:1    0    1M  0 part  
├─sda2                      8:2    0    1G  0 part /boot  
└─sda3                      8:3    0   63G  0 part  
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /  
sdb                         8:16   0  2.5G  0 disk  
├─sdb1                      8:17   0    2G  0 part  
└─sdb2                      8:18   0  511M  0 part  
sdc                         8:32   0  2.5G  0 disk  
├─sdc1                      8:33   0    2G  0 part  
└─sdc2                      8:34   0  511M  0 part  
```  
##### 6. 
```
sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev  
/sdb1 /dev/sdc1  
mdadm: Note: this array has metadata at the start and  
    may not be suitable as a boot device.  If you plan to  
    store '/boot' on this device please ensure that  
    your boot-loader understands md/v1.x metadata, or use  
    --metadata=0.90  
mdadm: size set to 2094080K  
Continue creating array? y  
mdadm: Defaulting to version 1.2 metadata  
mdadm: array /dev/md0 started.  
```  
```
lsblk  
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT  
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128  
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029  
loop3                       7:3    0 55.5M  1 loop  /snap/core18/2344  
loop4                       7:4    0 44.7M  1 loop  /snap/snapd/15534  
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1434  
loop6                       7:6    0 67.8M  1 loop  /snap/lxd/22753  
sda                         8:0    0   64G  0 disk  
├─sda1                      8:1    0    1M  0 part  
├─sda2                      8:2    0    1G  0 part  /boot  
└─sda3                      8:3    0   63G  0 part  
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /  
sdb                         8:16   0  2.5G  0 disk  
├─sdb1                      8:17   0    2G  0 part  
│ └─md0                     9:0    0    2G  0 raid1  
└─sdb2                      8:18   0  511M  0 part  
sdc                         8:32   0  2.5G  0 disk  
├─sdc1                      8:33   0    2G  0 part  
│ └─md0                     9:0    0    2G  0 raid1  
└─sdc2                      8:34   0  511M  0 part  
```  
##### 7. 
```
sudo mdadm --create --verbose /dev/md1 --level=0 --raid-devices=2 /dev  
/sdb2 /dev/sdc2  
mdadm: chunk size defaults to 512K  
mdadm: Defaulting to version 1.2 metadata  
mdadm: array /dev/md1 started.  
```  
```
lsblk  
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT  
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128  
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029  
loop3                       7:3    0 55.5M  1 loop  /snap/core18/2344  
loop4                       7:4    0 44.7M  1 loop  /snap/snapd/15534  
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1434  
loop6                       7:6    0 67.8M  1 loop  /snap/lxd/22753  
sda                         8:0    0   64G  0 disk  
├─sda1                      8:1    0    1M  0 part  
├─sda2                      8:2    0    1G  0 part  /boot  
└─sda3                      8:3    0   63G  0 part  
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /  
sdb                         8:16   0  2.5G  0 disk  
├─sdb1                      8:17   0    2G  0 part  
│ └─md0                     9:0    0    2G  0 raid1  
└─sdb2                      8:18   0  511M  0 part  
  └─md1                     9:1    0 1018M  0 raid0  
sdc                         8:32   0  2.5G  0 disk  
├─sdc1                      8:33   0    2G  0 part  
│ └─md0                     9:0    0    2G  0 raid1  
└─sdc2                      8:34   0  511M  0 part  
  └─md1                     9:1    0 1018M  0 raid0  
```  
##### 8. 
```
sudo pvs  
  PV         VG        Fmt  Attr PSize   PFree  
  /dev/sda3  ubuntu-vg lvm2 a--  <63.00g <31.50g  
```  
```  
sudo pvcreate /dev/md0  
  Physical volume "/dev/md0" successfully created.  
```  
```
sudo pvcreate /dev/md1  
  Physical volume "/dev/md1" successfully created.  
```  
```
sudo pvs  
  PV         VG        Fmt  Attr PSize    PFree  
  /dev/md0             lvm2 ---    <2.00g   <2.00g  
  /dev/md1             lvm2 ---  1018.00m 1018.00m  
  /dev/sda3  ubuntu-vg lvm2 a--   <63.00g  <31.50g  
```  
##### 9.
```
sudo vgcreate vg0 /dev/md0 /dev/md1  
  Volume group "vg0" successfully created  
```  
```
sudo vgs  
  VG        #PV #LV #SN Attr   VSize   VFree  
  ubuntu-vg   1   1   0 wz--n- <63.00g <31.50g  
  vg0         2   0   0 wz--n-  <2.99g  <2.99g  
```  
##### 10.  
```
sudo lvcreate -L 100Mb -n lv0 /dev/vg0 /dev/md1  
  Logical volume "lv0" created.  
```  
```
sudo lvdisplay /dev/vg0/lv0  
  --- Logical volume ---  
  LV Path                /dev/vg0/lv0  
  LV Name                lv0  
  VG Name                vg0  
  LV UUID                tg05ga-byoW-7iPO-fbG4-Wqu8-l9Jg-j9cgsD  
  LV Write Access        read/write  
  LV Creation host, time vagrant, 2022-05-01 06:05:01 +0000  
  LV Status              available  
  # open                 0  
  LV Size                100.00 MiB  
  Current LE             25  
  Segments               1  
  Allocation             inherit  
  Read ahead sectors     auto  
  - currently set to     4096  
  Block device           253:1  
```  
###### 11.  
```
sudo mkfs.ext4 /dev/vg0/lv0  
mke2fs 1.45.5 (07-Jan-2020)  
Creating filesystem with 25600 4k blocks and 25600 inodes  
  
Allocating group tables: done  
Writing inode tables: done  
Creating journal (1024 blocks): done  
Writing superblocks and filesystem accounting information: done  
```
##### 12.  
``` mkdir /tmp/new ```  
``` sudo mount /dev/vg0/lv0 /tmp/new/ ```
```
sudo mount | grep "^/dev"  
/dev/mapper/ubuntu--vg-ubuntu--lv on / type ext4 (rw,relatime)  
/dev/sda2 on /boot type ext4 (rw,relatime)  
/dev/mapper/vg0-lv0 on /tmp/new type ext4 (rw,relatime,stripe=256)  
```  
##### 13.  
```
sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz  
--2022-05-01 06:10:27--  https://mirror.yandex.ru/ubuntu/ls-lR.gz  
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183  
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.  
HTTP request sent, awaiting response... 200 OK  
Length: 22830372 (22M) [application/octet-stream]  
Saving to: ‘/tmp/new/test.gz’  
  
/tmp/new/test.gz       100%[=========================>]  21.77M   869KB/s    in 33s  
  
2022-05-01 06:11:00 (676 KB/s) - ‘/tmp/new/test.gz’ saved [22830372/22830372]  
```  
##### 14.  
```
lsblk  
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT  
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128  
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029  
loop3                       7:3    0 55.5M  1 loop  /snap/core18/2344  
loop4                       7:4    0 44.7M  1 loop  /snap/snapd/15534  
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1434  
loop6                       7:6    0 67.8M  1 loop  /snap/lxd/22753  
sda                         8:0    0   64G  0 disk  
├─sda1                      8:1    0    1M  0 part  
├─sda2                      8:2    0    1G  0 part  /boot  
└─sda3                      8:3    0   63G  0 part  
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /  
sdb                         8:16   0  2.5G  0 disk  
├─sdb1                      8:17   0    2G  0 part  
│ └─md0                     9:0    0    2G  0 raid1  
└─sdb2                      8:18   0  511M  0 part  
  └─md1                     9:1    0 1018M  0 raid0  
    └─vg0-lv0             253:1    0  100M  0 lvm   /tmp/new  
sdc                         8:32   0  2.5G  0 disk  
├─sdc1                      8:33   0    2G  0 part  
│ └─md0                     9:0    0    2G  0 raid1  
└─sdc2                      8:34   0  511M  0 part  
  └─md1                     9:1    0 1018M  0 raid0  
    └─vg0-lv0             253:1    0  100M  0 lvm   /tmp/new  
```  
##### 15.  
```
vagrant@vagrant:~$ gzip -t /tmp/new/test.gz  
vagrant@vagrant:~$ echo $?  
0  
```  
##### 16. 
```
sudo pvmove /dev/md1 /dev/md0  
  /dev/md1: Moved: 20.00%  
  /dev/md1: Moved: 100.00%  
```  
##### 17. 
```
sudo mdadm --fail /dev/md0 /dev/sdb1  
mdadm: set /dev/sdb1 faulty in /dev/md0  
```  
```
cat /proc/mdstat  
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]  
md1 : active raid0 sdc2[1] sdb2[0]  
      1042432 blocks super 1.2 512k chunks  
  
md0 : active raid1 sdc1[1] sdb1[0](F)  
      2094080 blocks super 1.2 [2/1] [_U]  
  
unused devices: <none>  
```  
##### 18.  
```
sudo dmesg | grep raid1  
[ 2867.042362] md/raid1:md0: not clean -- starting background reconstruction  
[ 2867.042363] md/raid1:md0: active with 2 out of 2 mirrors  
[ 4152.384730] md/raid1:md0: Disk failure on sdb1, disabling device.  
               md/raid1:md0: Operation continuing on 1 devices.  
```  
##### 19.  
```
vagrant@vagrant:~$ gzip -t /tmp/new/test.gz  
vagrant@vagrant:~$ echo $?  
0  
```  
##### 20.  
```
vagrant@vagrant:~$ exit  
logout  
Connection to 127.0.0.1 closed.  
  
C:\data\devops\homework\hw1sysadm\vagrant>vagrant destroy  
    default: Are you sure you want to destroy the 'default' VM? [y/N] y  
==> default: Forcing shutdown of VM...  
==> default: Destroying VM and associated drives...  
  
C:\data\devops\homework\hw1sysadm\vagrant>  
```
