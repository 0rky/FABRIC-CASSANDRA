remote_command='
sudo systemctl start cassandra
sleep 3
'

for ip in `cat /home/$USER/ips.txt`
do
        ssh -o "StrictHostKeyChecking no" $ip "$remote_command"
        sleep 3
done

echo ">>>           Done with the Cassandra Cluster setup                   <<<"
echo ""
echo "*************************************************************************"
echo "      >>> Check Status: sudo systemctl status cassandra <<<"
echo "   >>> Check Status of all the nodes: sudo nodetool status <<< "
echo "  >>> WAIT FOR 30 SECONDS OR MORE FOR THE CLUSTER TO STABALIZE <<< "
echo "*************************************************************************"