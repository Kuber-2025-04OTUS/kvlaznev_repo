command:
```shell
kubectl debug -it nginx -n debug --image=alpine --target=nginx --share-processes -- /bin/sh 
```
Output:
```
Targeting container "nginx". If you don't see processes from this container it may be because the container runtime doesn't support this feature.
--profile=legacy is deprecated and will be removed in the future. It is recommended to explicitly specify a profile, for example "--profile=general".
Defaulting debug container name to debugger-bjmjc.
If you don't see a command prompt, try pressing enter.
```
command:
```shell
ls -la /proc/1/root/etc/nginx/
```
output:
```
total 48
drwxr-xr-x    3 root     root          4096 Oct  5  2020 .
drwxr-xr-x    1 root     root          4096 Jul 11 15:33 ..
drwxr-xr-x    2 root     root          4096 Oct  5  2020 conf.d
-rw-r--r--    1 root     root          1007 Apr 21  2020 fastcgi_params
-rw-r--r--    1 root     root          2837 Apr 21  2020 koi-utf
-rw-r--r--    1 root     root          2223 Apr 21  2020 koi-win
-rw-r--r--    1 root     root          5231 Apr 21  2020 mime.types
lrwxrwxrwx    1 root     root            22 Apr 21  2020 modules -> /usr/lib/nginx/modules
-rw-r--r--    1 root     root           643 Apr 21  2020 nginx.conf
-rw-r--r--    1 root     root           636 Apr 21  2020 scgi_params
-rw-r--r--    1 root     root           664 Apr 21  2020 uwsgi_params
-rw-r--r--    1 root     root          3610 Apr 21  2020 win-utf
```

command:
```shell
apk update && apk add tcpdump
```
output:
```
v3.22.0-369-g32a4d6f4dac [https://dl-cdn.alpinelinux.org/alpine/v3.22/main]
v3.22.0-370-gcc0d82933f4 [https://dl-cdn.alpinelinux.org/alpine/v3.22/community]
OK: 26313 distinct packages available
(1/2) Installing libpcap (1.10.5-r1)
(2/2) Installing tcpdump (4.99.5-r1)
Executing busybox-1.37.0-r18.trigger
OK: 8 MiB in 18 packages
```

command:
```shell
 tcpdump -nn -i any -e port 80
```
output:
```
tcpdump: WARNING: any: That device doesn't support promiscuous mode
(Promiscuous mode not supported on the "any" device)
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on any, link-type LINUX_SLL2 (Linux cooked v2), snapshot length 262144 bytes
16:07:03.172862 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.38550 > 127.0.0.1.80: Flags [S], seq 2309711012, win 65495, options [mss 65495,sackOK,TS val 2594821891 ecr 0,nop,wscale 7], length 0
16:07:03.172872 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.38550: Flags [S.], seq 3824451679, ack 2309711013, win 65483, options [mss 65495,sackOK,TS val 2594821891 ecr 2594821891,nop,wscale 7], length 0
16:07:03.172880 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.38550 > 127.0.0.1.80: Flags [.], ack 1, win 512, options [nop,nop,TS val 2594821891 ecr 2594821891], length 0
16:07:03.183292 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 1506: 127.0.0.1.38550 > 127.0.0.1.80: Flags [P.], seq 1:1435, ack 1, win 512, options [nop,nop,TS val 2594821901 ecr 2594821891], length 1434: HTTP: GET / HTTP/1.1
16:07:03.183307 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.38550: Flags [.], ack 1435, win 502, options [nop,nop,TS val 2594821901 ecr 2594821901], length 0
16:07:03.183410 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 252: 127.0.0.1.80 > 127.0.0.1.38550: Flags [P.], seq 1:181, ack 1435, win 512, options [nop,nop,TS val 2594821901 ecr 2594821901], length 180: HTTP: HTTP/1.1 304 Not Modified
16:07:03.183421 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.38550 > 127.0.0.1.80: Flags [.], ack 181, win 511, options [nop,nop,TS val 2594821901 ecr 2594821901], length 0
16:07:18.338907 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.38550 > 127.0.0.1.80: Flags [.], ack 181, win 512, options [nop,nop,TS val 2594837057 ecr 2594821901], length 0
16:07:18.338945 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.38550: Flags [.], ack 1435, win 512, options [nop,nop,TS val 2594837057 ecr 2594821901], length 0
```

command:
```shell
kubectl debug node/cl18i6vaeqpjtnaelkf6-eded -it --image=busybox
```
output:
```
--profile=legacy is deprecated and will be removed in the future. It is recommended to explicitly specify a profile, for example "--profile=general".
Creating debugging pod node-debugger-cl18i6vaeqpjtnaelkf6-eded-nsnd5 with container debugger on node cl18i6vaeqpjtnaelkf6-eded.
If you don't see a command prompt, try pressing enter.
```

command:
```shell
cat /host/var/log/pods/debug_nginx_a49d4d55-6b7a-4ec7-a463-8f3bbdc57f21/nginx/0.log
```
output:
```
2025-07-11T15:55:49.1006523Z stdout F 127.0.0.1 - - [11/Jul/2025:23:55:49 +0800] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:136.0) Gecko/20100101 Firefox/136.0" "-"
2025-07-11T15:55:53.362159674Z stdout F 127.0.0.1 - - [11/Jul/2025:23:55:53 +0800] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:136.0) Gecko/20100101 Firefox/136.0" "-"
2025-07-11T15:55:53.436721686Z stdout F 127.0.0.1 - - [11/Jul/2025:23:55:53 +0800] "GET /favicon.ico HTTP/1.1" 404 153 "http://localhost:8080/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:136.0) Gecko/20100101 Firefox/136.0" "-"
2025-07-11T15:55:53.436776062Z stderr F 2025/07/11 23:55:53 [error] 7#7: *2 open() "/usr/share/nginx/html/favicon.ico" failed (2: No such file or directory), client: 127.0.0.1, server: localhost, request: "GET /favicon.ico HTTP/1.1", host: "localhost:8080", referrer: "http://localhost:8080/"
2025-07-11T15:56:20.489060174Z stdout F 127.0.0.1 - - [11/Jul/2025:23:56:20 +0800] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:136.0) Gecko/20100101 Firefox/136.0" "-"
2025-07-11T16:07:03.18354781Z stdout F 127.0.0.1 - - [12/Jul/2025:00:07:03 +0800] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:136.0) Gecko/20100101 Firefox/136.0" "-"
```

command:
```shell
kubectl debug -it nginx -n debug --image=alpine --target=nginx --share-processes --profile=sysadmin -- /bin/sh
```
command:
```shell
apk update && apk add strace
```
command:
```shell
strace -p 1
```
output:
```
strace: Process 1 attached
rt_sigsuspend([], 8
```