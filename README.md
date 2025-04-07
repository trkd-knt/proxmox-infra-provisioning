# proxmox-infra-provisioning


```
Host pvegpu1
        HostName 126.66.1.111
        IdentityFile </path/to/the/private_key>
        User terakado
        Port 10022

Host pve1
        HostName 126.66.1.111
        IdentityFile </path/to/the/private_key>
        User terakado
        Port 10122
```

ssh -L 8006:localhost:8006 terakado@126.66.1.111 -i ~/.ssh/medops_trkd_rsa -p 10022
ssh -L 8006:localhost:8006 terakado@126.66.1.111 -i ~/.ssh/medops_trkd_rsa -p 10122


root@pvegpu1:~# ls /sys/class/net/
bonding_masters  enp1s0  lo  vmbr0  wlp2s0
root@pvegpu1:~# 


terakado@pvegpu1:~$ sudo su -
[sudo] password for terakado: 
root@pvegpu1:~# cat /etc/network/interfaces
auto lo
iface lo inet loopback

iface enp1s0 inet manual

auto vmbr0
iface vmbr0 inet static
	address 192.168.100.195/24
	gateway 192.168.100.1
	bridge-ports enp1s0
	bridge-stp off
	bridge-fd 0

iface wlp2s0 inet manual


source /etc/network/interfaces.d/*
root@pvegpu1:~# cat /etc/network/interfaces.d/*
cat: '/etc/network/interfaces.d/*': No such file or directory
root@pvegpu1:~# 

root@pvegpu1:~# ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master vmbr0 state UP group default qlen 1000
    link/ether 38:f7:cd:c8:b6:81 brd ff:ff:ff:ff:ff:ff
3: wlp2s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 1c:ce:51:f7:00:a0 brd ff:ff:ff:ff:ff:ff
4: vmbr0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 38:f7:cd:c8:b6:81 brd ff:ff:ff:ff:ff:ff
    inet 192.168.100.195/24 scope global vmbr0
       valid_lft forever preferred_lft forever
    inet6 fe80::3af7:cdff:fec8:b681/64 scope link 
       valid_lft forever preferred_lft forever
root@pvegpu1:~# 
