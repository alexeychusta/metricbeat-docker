#!/bin/sh


docker stop metricbeat
docker rm metricbeat

docker run -d \
	--name metricbeat \
        --restart unless-stopped \
	--user=root \
	--mount type=bind,source=`pwd`/conf/metricbeat.yml,target=/usr/share/metricbeat/metricbeat.yml,readonly \
	--mount type=bind,source=`pwd`/conf/modules.d,target=/usr/share/metricbeat/modules.d,readonly \
	--mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock,readonly \
       	--mount type=bind,source=/proc,target=/hostfs/proc,readonly \
	--mount type=bind,source=/sys/fs/cgroup,target=/hostfs/sys/fs/cgroup,readonly \
	--mount type=bind,source=/,target=/hostfs,readonly \
	--net=host \
	docker.elastic.co/beats/metricbeat:7.9.3 -e -system.hostfs=/hostfs
