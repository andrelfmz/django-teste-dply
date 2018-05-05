# django-teste-dply

<p> http://ip_server ...(Aguardar 10 minutos)</p>
<p> admin/master123 </p>

# user-data (dply - Ubuntu 16.04)

	#!/bin/sh
	export DEBIAN_FRONTEND=noninteractive;
	apt-get update;
	apt-get -y upgrade;
	apt-get -y install docker.io python-pip git;
	pip install docker-compose;
	mkdir /tmp/mycompose;
	cd /tmp/mycompose;
	git clone https://github.com/andrelfmz/django-teste-dply.git .;
	docker-compose up -d;
	sleep 20;
	cat ./dados_bkp/dump_bkp_sql.sql | docker exec -i logus-db-container psql -Upostgres
	echo 1 > /tmp/mycompose/done
