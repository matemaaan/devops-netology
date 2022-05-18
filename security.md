# Безопасность
##### 1.  
![изображение](https://user-images.githubusercontent.com/89702147/169103066-990b5f93-3fc4-4aef-a32b-5e7cf1d57388.png)
##### 2.  
![изображение](https://user-images.githubusercontent.com/89702147/169104131-6b493d9b-e853-41b0-bdc3-ff10ed89cc7b.png)
##### 3.  
``` sudo apt install apache2 ```  
``` sudo mkdir /etc/apache2/ssl ```  
``` cp /etc/apache2/ssl ```  
``` sudo openssl req -new -x509 -days 90 -nodes -out cert.pem -keyout cert.key -subj "/C=RU/ST=Tyumen/L=Tyumen/O=Test/OU=Test/CN=test.local/CN=test" ```  
``` sudo a2enmod ssl ```  
``` sudo systemctl restart apache2 ```  
``` cd .. ```  
``` sudo nano sites-enabled/000-default.conf ```  
add  
```
<VirtualHost *:443>
    ServerName test.local
    DocumentRoot /var/www/apache/data
    SSLEngine on
    SSLCertificateFile ssl/cert.pem
    SSLCertificateKeyFile ssl/cert.key
</VirtualHost>
```
``` systemctl restart apache2 ```  
```
vagrant@vagrant:~$ curl https://test.local -k | head -n 25
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <!--
    Modified from the Debian original for Ubuntu
    Last updated: 2016-11-16
    See: https://launchpad.net/bugs/1288690
  -->
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Apache2 Ubuntu Default Page: It works</title>
    <style type="text/css" media="screen">
  * {
    margin: 0px 0px 0px 0px;
    padding: 0px 0px 0px 0px;
  }

  body, html {
    padding: 3px 3px 3px 3px;

    background-color: #D8DBE2;

    font-family: Verdana, sans-serif;
    font-size: 11pt;
    text-align: center;
100 10918  100 10918    0     0   710k      0 --:--:-- --:--:-- --:--:--  710k
(23) Failed writing body
```  
##### 4.  
```
./testssl.sh -e --fast --parallel https://test.local

ATTENTION: No cipher mapping file found!
Please note from 2.9 on testssl.sh needs files in "$TESTSSL_INSTALL_DIR/etc/" to function correctly.

Type "yes" to ignore this warning and proceed at your own risk --> yes

ATTENTION: No TLS data file found -- needed for socket-based handshakes
Please note from 2.9 on testssl.sh needs files in "$TESTSSL_INSTALL_DIR/etc/" to function correctly.

Type "yes" to ignore this warning and proceed at your own risk --> yes

No engine or GOST support via engine with your /usr/bin/openssl

###########################################################
    testssl.sh       3.0.6 from https://testssl.sh/

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.1.1f  31 Mar 2020" [~0 ciphers]
 on vagrant:/usr/bin/openssl
 (built: "Nov 24 13:20:48 2021", platform: "debian-amd64")


 Start 2022-05-18 18:03:38        -->> 127.0.0.1:443 (test.local) <<--

 rDNS (127.0.0.1):       --
 Testing with test.local:443 only worked using /usr/bin/openssl.
 Test results may be somewhat better if the --ssl-native option is used.
 Type "yes" to proceed and accept false negatives or positives --> yes
 Service detected:       HTTP


 Testing all 1 locally available ciphers against the server, ordered by encryption strength


Hexcode  Cipher Suite Name (OpenSSL)       KeyExch.   Encryption  Bits
--------------------------------------------------------------------------


 Done 2022-05-18 18:04:57 [ 166s] -->> 127.0.0.1:443 (test.local) <<--
 ```  
 ##### 5. 
 ``` sudo apt install openssh-server ```  
 ``` ssh-keygen ```
 ``` ssh-copy-id vagrant@vagrant ```
 ``` ssh vagrant@vagrant ```  
 ```
 Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed 18 May 2022 06:31:23 PM UTC

  System load:  0.06               Processes:             126
  Usage of /:   12.0% of 30.88GB   Users logged in:       1
  Memory usage: 29%                IPv4 address for eth0: 10.0.2.15
  Swap usage:   0%


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Wed May 18 18:30:44 2022 from 10.0.2.15
```  
##### 6.  
```
vagrant@vagrant:~$ cat .ssh/config
   Host vagrant
   HostName 10.0.2.15
   User vagrant
   Port 22
   IdentityFile ~/.ssh/id_rsa
   CertificateFile ~/.ssh.id_rsa.pub
```
##### 7.  
```
sudo tcpdump -c 100 -w 0001.pcap
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
100 packets captured
108 packets received by filter
0 packets dropped by kernel
```  
![изображение](https://user-images.githubusercontent.com/89702147/169121826-14c4f141-8cc9-47b7-95fb-b9d053fbf44c.png)

