export DEBIAN_FRONTEND=noninteractive

if [[ $# -lt 1 ]];
then
        echo " Usage: cluster_config.sh [option]"
        echo ""
        echo "option: use -V for Hadoop Installation"
        exit

fi

if [ "$1" = "-V" ];
then
        echo "Cassandra Version"
        cassandra_version="40x"
        cassandra_version_new="50x"

else
        echo "Please look for usage in this script"
        exit
fi

# TO DO: to check for each node in cluster whether nat64 is there or not and run it.
scripts=("install_java" \
	"install_cassandra" \
        "config_cassandra_node"
        )

pid=""

completed=1
master_ip=""

for ip in `cat /home/$USER/ips.txt`
do
        master_ip=$ip
        break
done

echo ">>> Installing necessary tools and softwares <<<"
echo " "
echo ">>> It will take no more than watching a movie trailer!!! <<< "
echo " "

for script in "${scripts[@]}"
do
        log_file="LOG-"$script".log"
        command='bash /home/'$USER'/'$script'.sh '$cassandra_version' '$cassandra_version_new' &> /home/'$USER'/'$log_file''
        ssh -o "StrictHostKeyChecking no" $master_ip "$command" &
        pid="$pid $!"

        while true;
        do
                if ps -p $pid > /dev/null
                then
                        sleep 3
                else
                        break
                fi
        done

        echo "Running script $script :" "Done with stages ($completed / ${#scripts[@]})"
        completed=$((completed+1))

done

echo ">>> Done with the installation <<<"
echo ""
echo "*************************************************************************"
echo "      >>> Check the file /etc/cassandra/cassandra.yaml <<<"
echo "   >>> To run the Cassandra Cluster \"start_cassandra.sh\" <<< "
echo "*************************************************************************"