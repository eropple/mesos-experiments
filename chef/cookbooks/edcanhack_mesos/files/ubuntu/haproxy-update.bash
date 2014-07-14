#! /usr/bin/env bash

cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.prior
MASTER_LOCATION=$(mesos-leading-master.rb | sed 's,5050,8080,')
if [[ $? -eq 0 ]]
  then
  
  marathon-haproxy-cfg.bash ${MASTER_LOCATION} > /etc/haproxy/haproxy.cfg
  
  if [[ $? -eq 0 ]]
    then
    
    service haproxy restart
  else
    cp /etc/haproxy/haproxy.cfg.prior /etc/haproxy/haproxy.cfg
  fi
fi