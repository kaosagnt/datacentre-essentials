# Ubuntu Zabbix Server with MariaDB

Ian McWilliam 2025/05/01


## Ubuntu Server Configuration

[Ubuntu Server](https://ubuntu.com/server)

>Ubuntu Pro is a comprehensive subscription delivering enterprise-grade security, management tooling, and extended support for developers and organisations. Ubuntu Pro is free for personal use on up to five machines.
>
>Security updates for the full open source stack
Estate monitoring and management
FIPS 140-2 certified modules and CIS hardening
Minimise rolling reboots with Kernel Livepatch
Optional weekday or 24/7 support tiers


**NOTE:** All passwords presented here are examples and MUST be changed if using in production.



After installing Ubuntu Server Virtual Machine

Ubuntu Admin account

	ladmin: !Tafe@nsw2025

### Update OS {#updateos}

	sudo apt update
	sudo apt upgrade

### Install Ubuntu deb packages for docker {#debdocker}

	sudo apt install docker.io docker-compose-v2 docker-buildx

Add administrator accounts to docker group

	sudo usermod -aG docker ladmin


### Create Break Glass Admin Account

	sudo adduser bgadmin
	sudo usermod -aG sudo bgadmin
	sudo usermod -aG docker bgadmin


### Firewall Settings {#fwall}

- Enable default firewall settings (Ping enabled by default)
- Enable rate limited ssh login

	sudo ufw enable
	sudo ufw limit ssh/tcp

### Set DCHP / Static Address {#dhcp}

Set dhcp or Static IPv4 address

Edit the netplan file or use the netplan tools.

File is YAML so not tabs only spaces and columns MUST line up correctly to parse.

### set dhcp on

/etc/netplan/50-cloud-init.yaml

```
network:
  version: 2
  ethernets:
    ens33:
      dhcp4: true

```

### Set static IPv4 add the following

```
      dhcp4: no
      addresses:
        - 192.168.xx.xx/24
      routes:
        - to: default
          via: 192.168.xx.254
      nameservers:
        addresses: [192.168.xx.xx, 192.168.xx.xx]

```

	sudo netplan apply

### Helpful networking commands

	ip link
	ip address show
	netplan status


### Set SSH login banner

SSH: port 22

create file /etc/banner.net with the following content.

```
            ***** This service is for authorised clients only *****

   ________________________________________________________________________
    WARNING    It is a criminal offence to:                                
               i. Obtain access to data without authority                  
               ii Damage, delete, alter or insert data without authority   
   ________________________________________________________________________



```

Edit /etc/ssh/sshd_config.d/50-cloud-init.conf and add the line.

```
banner /etc/banner.net
```

Restart SSHD

	systemctl restart ssh

---

## Zabbix 7.0 LTS {#zbxlts}

- Create zabbix system account user with no login to store runtime data, etc
- Set permissions on directory structure.

	adduser --system --group --home /var/lib/zabbix-data zabbix

	chmod 711 /var/lib/zabbix-data

	mkdir -p /var/lib/zabbix-data/zabbix-server-live/{cnf,env}

	chmod 700 /var/lib/zabbix-data/zabbix-server-live/{cnf,env}


### Start / Stop Zabbix Server / Web / Mariadb {#sszwm}

- All Zabbix servers set to automatically start on boot if not stopped.
- Can change in docker-compose.yml file to 'always' if required.
  
Need to be root

	sudo bash
	cd /var/lib/zabbix-data/zabbix-server-live/

To start Zabbix Docker container services

	docker compose up -d

To stop Zabbix Docker container services

	docker compose down

Zabbix Server

```
Exposed Ports:
	10050/tcp
	10051/tcp

```

Zabbix Web

	http://192.168.XX.XX:8080/

default zabbix web username / password

	Admin:	zabbix

```
Exposed Ports:
	8080/tcp
	8443/tcp -> HTTPS not configured
```

### View Zabbix Log Files {#vzlf}

	docker logs zabbix-server
	docker logs zabbix-web
	docker logs zabbix-agent
	docker logs mariadb-server


### List Docker Images {#ldi}

	docker images

```
REPOSITORY                         TAG                 IMAGE ID       CREATED        SIZE
zabbix/zabbix-server-mysql         ubuntu-7.0-latest   b2359c4d0ec8   7 days ago     328MB
zabbix/zabbix-agent2               7.0-ubuntu-latest   b87bf787747a   7 days ago     143MB
zabbix/zabbix-web-apache-mysql     ubuntu-7.0-latest   c2802158f95f   7 days ago     512MB
nagios-server-live-nagios-server   latest              b01e06294287   2 weeks ago    938MB
mariadb                            lts                 3b9caf5af534   2 months ago   327MB
```


### Zabbix Docker Container Documentation {#zdcdoc}

[https://www.zabbix.com/container_images](https://www.zabbix.com/container_images)

[https://www.zabbix.com/documentation/current/en/manual/installation/containers](https://www.zabbix.com/documentation/current/en/manual/installation/containers)

### Zabbix Server / MySQL

[https://hub.docker.com/r/zabbix/zabbix-server-mysql/](https://hub.docker.com/r/zabbix/zabbix-server-mysql/)

### Zabbix Windows Agent 2

```
Zabbix Windows agent 2 v7.0.11
Packaging:	MSI
Encryption:	No encryption
Linkage:	Static

Checksum:	
sha256:	b324fac33f1cabc272dcddb50b6ed1675642b1d719ac1c630052c34d83eddd7c
sha1: 800fab634d5dfcf9b572533a3ee8ce386f37ab84
md5: 43eee60f24e907504617132c79d8bf80

DOWNLOAD https://cdn.zabbix.com/zabbix/binaries/stable/7.0/7.0.11/zabbix_agent2_plugins-7.0.11-windows-amd64.msi

Manual:
https://www.zabbix.com/documentation/7.0/en/manual/concepts/agent2

```

### Configure host in Zabbix Server

[https://blog.zabbix.com/monitoring-windows-servers-with-zabbix-agent/29945/](https://blog.zabbix.com/monitoring-windows-servers-with-zabbix-agent/29945/)

To set up a host on Zabbix Server, go to the Zabbix frontend and go to Data collection > Hosts.

Then, click Create host (located in the top right) and configure the following details:

```

• The hostname (WSRV01)
• An identifying display name (such as ‘Windows Server’)
• The template (select ‘Windows by Zabbix Agent’)
• The group (assigns the server to an appropriate group)
• The interface (choose the agent monitoring option and enter the IP of the server)

```


---

## MariaDB

[https://mariadb.org/](https://mariadb.org/)

Database users:

	root: 	$DDGvbytt%67YU99873
	zabbix:	!RfghTTTss673VV$#
	zbx_monitor: 3$Rfsffff$#76ENM!

[https://hub.docker.com/_/mariadb](https://hub.docker.com/_/mariadb)

Last Long Term Support Release

mariadb:lts

MariaDB Server 1:11.4.5+maria~ubu2404

To access the MariaDB database server:

	docker exec -it mariadb-server bash
	mariadb -h 127.0.0.1 -u root -p

```
CREATE user 'zabbix'@'localhost' IDENTIFIED BY '!RfghTTTss673VV$#';
GRANT all PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';

CREATE user 'zabbix'@'mariadb-server' IDENTIFIED BY '!RfghTTTss673VV$#';
GRANT all PRIVILEGES ON zabbix.* TO 'zabbix'@'mariadb-server';

CREATE user 'zabbix'@'172.16.239.101' IDENTIFIED BY '!RfghTTTss673VV$#';
GRANT all PRIVILEGES ON zabbix.* TO 'zabbix'@'172.16.239.101';

CREATE user 'zabbix'@'172.16.239.102' IDENTIFIED BY '!RfghTTTss673VV$#';
GRANT all PRIVILEGES ON zabbix.* TO 'zabbix'@'172.16.239.102';

FLUSH PRIVILEGES;
```

To remove Zabbix Database users:

```
DROP USER 'zabbix'@'localhost';
DROP USER 'zabbix'@'mariadb-server';
DROP USER 'zabbix'@'172.16.239.101';
DROP USER 'zabbix'@'172.16.239.102';
```

Zabbix Mysql monitoring:

[https://www.zabbix.com/integrations/mysql#mysql_agent2](https://www.zabbix.com/integrations/mysql#mysql_agent2)

```
CREATE USER 'zbx_monitor'@'172.16.239.104' IDENTIFIED BY '3$Rfsffff$#76ENM!';
GRANT REPLICATION CLIENT,PROCESS,SHOW DATABASES,SHOW VIEW,SLAVE MONITOR ON *.* TO 'zbx_monitor'@'172.16.239.104';

FLUSH PRIVILEGES;
```

To remove Zabbix Database monitoring users:

```
DROP USER 'zbx_monitor'@'172.16.239.104';
```

In Zabbix Web front end:

Add new host for monitoring:

Host name: mariadb-server

Visible name: Zabbix MariaDB Server

Templates: MySQL by Zabbix agent 2

Host groups: Databases

Interfaces

Type: Agent

IP address: 172.16.239.104

Port: 10051

IPDNS: IP

Description: Zabbix MariaDB Server

On the Macros tab:
 - Add 3 macros to specify address, username and password
 - Click on Add and to the new entry:

```
Macro: {$MYSQL.DSN}
Value: tcp://172.16.239.103:3306 (or whatever IP/FQDN of the database server)
Description: Zabbix MariaDB DSN
```

 - Click Add for the second macro:

```
Macro: {$MYSQL.USER}
Value: zbx_monitor (or whatever user your database you have)
Description: Zabbix MariaDB monitor user
```

- Click Add for the third macro:

```
Macro: {$MYSQL.PASSWORD}
Value: 3$Rfsffff$#76ENM!    (Change form text to secret text)
Description: Zabbix MariaDB monitor user password
```

Monitoring -> Latest data

- In the filter section, type the name of your database server in the Hosts box.
- Click Apply

A list of items should be displayed for it.


---

[https://mariadb.com/kb/en/using-healthcheck-sh/](https://mariadb.com/kb/en/using-healthcheck-sh/)

[https://mariadb.org/mariadb-server-docker-official-images-healthcheck-without-mysqladmin/](https://mariadb.org/mariadb-server-docker-official-images-healthcheck-without-mysqladmin/)

```
healthcheck:
  test: [
          "CMD",
          "healthcheck.sh",
          "--defaults-extra-file=/var/lib/mariadb/.my-healthcheck.cnf",
          "--connect",
          "--innodb_initialized"
        ]
  start_period: 1m
  start_interval: 10s
  interval: 1m
  timeout: 5s
  retries: 3


depends_on:
  mariadb-server:
    condition: service_healthy

```

	pgrep zabbix_agent2
	pgrep zabbix_server

	docker ps -f health=starting
	docker ps -f health=healthy

	docker compose ls

[https://docs.docker.com/reference/cli/docker/container/ls/#filtering](https://docs.docker.com/reference/cli/docker/container/ls/#filtering)

---

	ladmin@dca-mon01:~$ sudo bash
[sudo] password for ladmin: 

```
root@dca-mon01:/home/ladmin# ls -al /var/lib/zabbix-data/zabbix-server-live/
total 12
drwxr-x--- 4 zabbix zabbix   78 May 10 20:10 .
drwx--x--x 4 zabbix zabbix   47 Apr  6 18:50 ..
drwx------ 5 zabbix zabbix   55 Mar 30 18:12 cnf
-rw-r--r-- 1 zabbix zabbix 7225 May 10 20:10 docker-compose.yml
drwx------ 2 zabbix zabbix  147 Mar 31 20:52 env
-rwxr-x--- 1 zabbix zabbix 1928 Apr  6 17:21 pull-docker-repo
```

	root@dca-mon01:/home/ladmin# cd /var/lib/zabbix-data/zabbix-server-live/

	root@dca-mon01:/var/lib/zabbix-data/zabbix-server-live# docker compose down

```
[+] Running 6/6
 ✔ Container zabbix-agent                     Removed                      0.2s 
 ✔ Container zabbix-web                       Re...                        2.6s 
 ✔ Container zabbix-server                    Removed                      1.7s 
 ✔ Container mariadb-server                   Removed                      0.5s 
 ✔ Network zabbix-server-live_zabbix-ext-net  Removed                      0.2s 
 ✔ Network zabbix-server-live_zabbix-int-net  Removed                      0.2s 
```


	root@dca-mon01:/var/lib/zabbix-data/zabbix-server-live# docker compose up -d

```
[+] Running 6/6
 ✔ Network zabbix-server-live_zabbix-ext-net  Created                      0.1s 
 ✔ Network zabbix-server-live_zabbix-int-net  Created                      0.1s 
 ✔ Container mariadb-server                   Healthy                     24.6s 
 ✔ Container zabbix-server                    Healthy                     24.6s 
 ✔ Container zabbix-web                       He...                       29.5s 
 ✔ Container zabbix-agent                     Started                     30.1s 
```

	root@dca-mon01:/var/lib/zabbix-data/zabbix-server-live# docker compose ps

```
NAME             IMAGE                                              COMMAND                  SERVICE          CREATED              STATUS                        PORTS
mariadb-server   mariadb:lts                                        "docker-entrypoint.s…"   mariadb-server   About a minute ago   Up About a minute (healthy)   
zabbix-agent     zabbix/zabbix-agent2:7.0-ubuntu-latest             "/usr/bin/docker-ent…"   zabbix-agent     About a minute ago   Up About a minute (healthy)   
zabbix-server    zabbix/zabbix-server-mysql:ubuntu-7.0-latest       "/usr/bin/docker-ent…"   zabbix-server    About a minute ago   Up About a minute (healthy)   0.0.0.0:10051->10051/tcp, :::10051->10051/tcp
zabbix-web       zabbix/zabbix-web-apache-mysql:ubuntu-7.0-latest   "docker-entrypoint.sh"   zabbix-web       About a minute ago   Up About a minute (healthy)   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp, 0.0.0.0:8443->8443/tcp, :::8443->8443/tcp
```




