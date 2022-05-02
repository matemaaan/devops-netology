# Лекция компьютерные сети  
##### 1.  
```
telnet stackoverflow.com 80  
Trying 151.101.1.69...  
Connected to stackoverflow.com.  
Escape character is '^]'.  
GET /questions HTTP/1.0  
HOST: stackoverflow.com  
  
HTTP/1.1 301 Moved Permanently  
cache-control: no-cache, no-store, must-revalidate  
location: https://stackoverflow.com/questions  
x-request-guid: d22a7bf2-2617-4181-be01-f23855c2f028  
feature-policy: microphone 'none'; speaker 'none'  
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com  
Accept-Ranges: bytes  
Date: Mon, 02 May 2022 04:51:35 GMT  
Via: 1.1 varnish  
Connection: close  
X-Served-By: cache-hhn4039-HHN  
X-Cache: MISS  
X-Cache-Hits: 0  
X-Timer: S1651467095.451008,VS0,VE170  
Vary: Fastly-SSL  
X-DNS-Prefetch-Control: off  
Set-Cookie: prov=a649728b-ae05-d14c-81ca-daf86f6e206d; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly  
  
Connection closed by foreign host.  
```  
Редирект на https.  
##### 2. на фото
##### 3. на фото  
##### 4.  
```
whois 94.25.191.206  
% This is the RIPE Database query service.  
% The objects are in RPSL format.  
%  
% The RIPE Database is subject to Terms and Conditions.  
% See http://www.ripe.net/db/support/db-terms-conditions.pdf  
  
% Note: this output has been filtered.  
%       To receive output for a database update, use the "-B" flag.  
  
% Information related to '94.25.176.0 - 94.25.191.255'  
  
% Abuse contact for '94.25.176.0 - 94.25.191.255' is 'abuse-mailbox@megafon.ru'  
  
inetnum:        94.25.176.0 - 94.25.191.255  
netname:        MF-URAL-MBB-YOTA-GDC  
country:        RU  
mnt-lower:      GDC-TR-CoreIP  
mnt-routes:     GDC-TR-CoreIP  
mnt-domains:    MEGAFON-DNS-MNT  
mnt-lower:      MEGAFON-AUTO-MNT  
admin-c:        MA23317-RIPE  
tech-c:         MA23317-RIPE  
status:         LIR-PARTITIONED PA  
mnt-by:         MEGAFON-RIPE-MNT  
created:        2021-08-16T13:23:23Z  
last-modified:  2021-08-16T13:23:23Z  
source:         RIPE  
  
role:           Mobile  
address:        Samara  
nic-hdl:        MA23317-RIPE  
mnt-by:         GDC-TR-CoreIP  
created:        2020-02-05T11:44:29Z  
last-modified:  2020-02-05T11:44:29Z  
source:         RIPE # Filtered  
  
% Information related to '94.25.184.0/21AS25159'  
  
route:          94.25.184.0/21  
descr:          MF-MOSCOW-MBB-YOTA-94-25-176  
origin:         AS25159  
mnt-by:         MEGAFON-AUTO-MNT  
mnt-by:         GDC-TR-CoreIP  
created:        2016-11-03T08:07:17Z  
last-modified:  2022-02-11T13:17:50Z  
source:         RIPE  
  
% This query was served by the RIPE Database Query Service version 1.102.3 (WAGYU)  
```  
##### 5.  
```
traceroute -I 8.8.8.8  
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets  
 1  _gateway (192.168.247.2)  0.133 ms  0.063 ms  0.076 ms  
 2  * * *  
 3  * * *  
 4  * * *  
 5  * * *  
 6  * * *  
 7  * * *  
 8  * * *  
 9  * * *  
10  * * *  
11  * * *  
12  * * *  
13  * * *  
14  * * *  
15  * * *  
16  * * *  
17  * * *  
18  * * *  
19  * * *  
20  * * *  
21  * * *  
22  * * *  
23  * * *  
24  * * *  
25  dns.google (8.8.8.8)  162.109 ms  162.297 ms  162.284 ms  
```  
traceroute в виртулаке нормально не отработал, вероятно причина в NAT  
```
tracert 8.8.8.8

Трассировка маршрута к dns.google [8.8.8.8]
с максимальным числом прыжков 30:

  1     9 ms     1 ms     1 ms  192.168.84.227
  2     *        *        *     Превышен интервал ожидания для запроса.
  3     *        *        *     Превышен интервал ожидания для запроса.
  4     *        *        *     Превышен интервал ожидания для запроса.
  5     *        *        *     Превышен интервал ожидания для запроса.
  6     *        *        *     Превышен интервал ожидания для запроса.
  7     *     1519 ms   152 ms  83.149.11.158
  8     *        *        *     Превышен интервал ожидания для запроса.
  9     *        *        *     Превышен интервал ожидания для запроса.
 10    67 ms    60 ms    66 ms  178.176.133.15
 11   352 ms   369 ms   348 ms  108.170.250.66
 12    91 ms    99 ms    99 ms  209.85.255.136
 13   151 ms    80 ms    82 ms  209.85.254.20
 14    96 ms    80 ms    88 ms  216.239.49.113
 15     *        *        *     Превышен интервал ожидания для запроса.
 16     *        *        *     Превышен интервал ожидания для запроса.
 17     *        *        *     Превышен интервал ожидания для запроса.
 18     *        *        *     Превышен интервал ожидания для запроса.
 19     *        *        *     Превышен интервал ожидания для запроса.
 20     *        *        *     Превышен интервал ожидания для запроса.
 21     *        *        *     Превышен интервал ожидания для запроса.
 22     *        *        *     Превышен интервал ожидания для запроса.
 23     *        *        *     Превышен интервал ожидания для запроса.
 24    79 ms    79 ms   108 ms  dns.google [8.8.8.8]
```
на хостовой машине с задержками но, выполнилось  
##### 6. на фото  
##### 7.  
```
dig dns.google NS  
  
; <<>> DiG 9.18.1-1ubuntu1-Ubuntu <<>> dns.google NS  
;; global options: +cmd  
;; Got answer:  
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 28816  
;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 9  
  
;; OPT PSEUDOSECTION:  
; EDNS: version: 0, flags:; udp: 65494  
;; QUESTION SECTION:  
;dns.google.			IN	NS  
  
;; ANSWER SECTION:  
dns.google.		5	IN	NS	ns2.zdns.google.  
dns.google.		5	IN	NS	ns4.zdns.google.  
dns.google.		5	IN	NS	ns1.zdns.google.  
dns.google.		5	IN	NS	ns3.zdns.google.  
  
;; ADDITIONAL SECTION:  
ns1.zdns.google.	5	IN	A	216.239.32.114  
ns2.zdns.google.	5	IN	A	216.239.34.114  
ns3.zdns.google.	5	IN	A	216.239.36.114  
ns4.zdns.google.	5	IN	A	216.239.38.114  
ns1.zdns.google.	5	IN	AAAA	2001:4860:4802:32::72  
ns2.zdns.google.	5	IN	AAAA	2001:4860:4802:34::72  
ns3.zdns.google.	5	IN	AAAA	2001:4860:4802:36::72  
ns4.zdns.google.	5	IN	AAAA	2001:4860:4802:38::72  
  
;; Query time: 792 msec  
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)  
;; WHEN: Mon May 02 21:34:16 +05 2022  
;; MSG SIZE  rcvd: 292  
```  
```
dig dns.google  
  
; <<>> DiG 9.18.1-1ubuntu1-Ubuntu <<>> dns.google  
;; global options: +cmd  
;; Got answer:  
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 50740  
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1  
  
;; OPT PSEUDOSECTION:  
; EDNS: version: 0, flags:; udp: 65494  
;; QUESTION SECTION:  
;dns.google.			IN	A  
  
;; ANSWER SECTION:  
dns.google.		5	IN	A	8.8.4.4  
dns.google.		5	IN	A	8.8.8.8  
  
;; Query time: 92 msec  
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)  
;; WHEN: Mon May 02 21:26:13 +05 2022  
;; MSG SIZE  rcvd: 71  
```  
##### 8.  
```
dig -x 8.8.8.8  
  
; <<>> DiG 9.18.1-1ubuntu1-Ubuntu <<>> -x 8.8.8.8  
;; global options: +cmd  
;; Got answer:  
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 13012  
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1  
  
;; OPT PSEUDOSECTION:  
; EDNS: version: 0, flags:; udp: 65494  
;; QUESTION SECTION:  
;8.8.8.8.in-addr.arpa.		IN	PTR  
  
;; ANSWER SECTION:  
8.8.8.8.in-addr.arpa.	5	IN	PTR	dns.google.  
  
;; Query time: 4 msec  
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)  
;; WHEN: Mon May 02 21:28:53 +05 2022  
;; MSG SIZE  rcvd: 73  
```  
```
dig -x 8.8.4.4  
  
; <<>> DiG 9.18.1-1ubuntu1-Ubuntu <<>> -x 8.8.4.4  
;; global options: +cmd  
;; Got answer:  
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 24934  
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1  
  
;; OPT PSEUDOSECTION:  
; EDNS: version: 0, flags:; udp: 65494  
;; QUESTION SECTION:  
;4.4.8.8.in-addr.arpa.		IN	PTR  
  
;; ANSWER SECTION:  
4.4.8.8.in-addr.arpa.	5	IN	PTR	dns.google.  
  
;; Query time: 64 msec  
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)  
;; WHEN: Mon May 02 21:29:13 +05 2022  
;; MSG SIZE  rcvd: 73  
```  
привязано имя dns.google для ip 8.8.8.8 и 8.8.4.4
