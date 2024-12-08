#!/usr/bin/env bash

remote_command='
bash $HOME/config_cassandra.sh
'

for ip in `cat /home/$USER/ips.txt`
do
        scp $HOME/config_cassandra.sh $ip:$HOME/
        ssh -o "StrictHostKeyChecking no" $ip "$remote_command"
        sleep 3
done